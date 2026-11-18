import { createHash } from 'node:crypto';
import { readFileSync, lstatSync, realpathSync } from 'node:fs';
import { resolve, relative, isAbsolute, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { execFileSync } from 'node:child_process';

export function validateLock(lock) {
  if (lock.schemaVersion !== 1 || lock.status !== 'source-foundation') throw new Error('Unsupported lock format/status');
  if (lock.upstream?.repository !== 'https://github.com/CachyOS/CachyOS-Live-ISO.git') throw new Error('Unexpected upstream repository');
  if (!/^[a-f0-9]{40}$/.test(lock.upstream.commit ?? '')) throw new Error('Upstream must be a full commit SHA');
  if (lock.target?.architecture !== 'x86_64' || lock.target.profile !== 'desktop') throw new Error('Unsupported initial target');
  if (lock.target.cpuMinimum !== 'not-qualified' || Object.hasOwn(lock, 'baselineBuilt')) throw new Error('Input locks do not qualify a build; use workflow evidence');
  const required = ['buildiso.sh', 'util.sh', 'util-msg.sh', 'util-iso.sh', 'util-iso-mount.sh', 'archiso/profiledef.sh', 'archiso/pacman.conf', 'archiso/packages_desktop.x86_64', '.github/workflows/build.yml', 'LICENSE'];
  if (!lock.reviewedFiles || Object.keys(lock.reviewedFiles).length !== required.length) throw new Error('Reviewed file set is incomplete');
  for (const path of required) {
    if (!/^[a-f0-9]{64}$/.test(lock.reviewedFiles[path] ?? '')) throw new Error(`Missing SHA-256: ${path}`);
  }
  return lock;
}

export function verifyReviewedFiles(lock, root) {
  validateLock(lock);
  const base = realpathSync(root);
  for (const [path, expected] of Object.entries(lock.reviewedFiles)) {
    const segments = path.split('/');
    if (isAbsolute(path) || segments.some(s => !s || s === '.' || s === '..' || s.includes('\\'))) throw new Error(`Unsafe path: ${path}`);
    let current = base;
    for (const segment of segments) {
      current = resolve(current, segment);
      if (lstatSync(current).isSymbolicLink()) throw new Error(`Linked input: ${path}`);
    }
    const rel = relative(base, realpathSync(current));
    if (rel.startsWith('..') || isAbsolute(rel) || !lstatSync(current).isFile()) throw new Error(`Invalid input: ${path}`);
    const actual = createHash('sha256').update(readFileSync(current)).digest('hex');
    if (actual !== expected) throw new Error(`Reviewed input changed: ${path}`);
  }
  return Object.keys(lock.reviewedFiles).length;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  try {
    const project = resolve(dirname(fileURLToPath(import.meta.url)), '..');
    const lock = validateLock(JSON.parse(readFileSync(resolve(project, 'config/source-lock.json'), 'utf8')));
    if (process.argv.length > 3) throw new Error('Usage: node scripts/validate-foundation.mjs [upstream-checkout]');
    if (process.argv[2]) {
      const root = resolve(process.argv[2]);
      const sha = execFileSync('git', ['-C', root, 'rev-parse', 'HEAD'], { encoding: 'utf8' }).trim();
      if (sha !== lock.upstream.commit) throw new Error('Upstream HEAD does not match lock');
      console.log(`Verified ${verifyReviewedFiles(lock, root)} reviewed upstream files at ${sha}`);
    } else {
      console.log(`Valid source lock: ${lock.upstream.commit}; target x86_64/desktop; build/boot evidence is recorded separately`);
    }
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}
