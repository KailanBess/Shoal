import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, readFileSync, writeFileSync, rmSync, symlinkSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, dirname } from 'node:path';
import { createHash } from 'node:crypto';
import { validateLock, verifyReviewedFiles } from '../scripts/validate-foundation.mjs';

const source = JSON.parse(readFileSync(new URL('../config/source-lock.json', import.meta.url), 'utf8'));
const copy = () => structuredClone(source);

test('accepts fixed source lock; refuses moving refs and alternate sources', () => {
  validateLock(source);
  for (const value of ['master', 'HEAD', 'a'.repeat(39)]) {
    const lock = copy(); lock.upstream.commit = value;
    assert.throws(() => validateLock(lock), /full commit/);
  }
  const lock = copy(); lock.upstream.repository = 'https://example.com/other.git';
  assert.throws(() => validateLock(lock), /repository/);
});

test('refuses incomplete file sets and unsupported qualification claims', () => {
  const lock = copy(); delete lock.reviewedFiles['buildiso.sh'];
  assert.throws(() => validateLock(lock), /incomplete/);
  const built = copy(); built.baselineBuilt = true;
  assert.throws(() => validateLock(built), /qualify/);
  const target = copy(); target.target.architecture = 'aarch64';
  assert.throws(() => validateLock(target), /target/);
});

test('checks exact bytes and rejects altered or linked source files', () => {
  const root = mkdtempSync(join(tmpdir(), 'shoal-source-test-'));
  try {
    const lock = copy();
    for (const path of Object.keys(lock.reviewedFiles)) {
      const file = join(root, path); mkdirSync(dirname(file), { recursive: true });
      const bytes = Buffer.from(`fixture ${path}\n`);
      writeFileSync(file, bytes);
      lock.reviewedFiles[path] = createHash('sha256').update(bytes).digest('hex');
    }
    assert.equal(verifyReviewedFiles(lock, root), 10);
    writeFileSync(join(root, 'buildiso.sh'), 'changed');
    assert.throws(() => verifyReviewedFiles(lock, root), /changed/);
    if (process.platform !== 'win32') {
      rmSync(join(root, 'buildiso.sh'));
      symlinkSync(join(root, 'util.sh'), join(root, 'buildiso.sh'));
      assert.throws(() => verifyReviewedFiles(lock, root), /Linked/);
    }
  } finally { rmSync(root, { recursive: true, force: true }); }
});
