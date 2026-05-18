# homebrew-siberia

Homebrew tap formula for [Siberia](https://github.com/cavanaug/siberia) — supply-chain hardening for pip, uv, npm, pnpm, and Cargo lockfile auditing.

---

## Install

```bash
brew tap cavanaug/tap
brew install siberia
```

Or install directly:

```bash
brew install cavanaug/tap/siberia
```

---

## Usage

Show the version:

```bash
siberia --version
```

Print shell exports:

```bash
siberia shellenv
```

Audit the current project:

```bash
siberia check --scan
```

---

## Updating

Users can update through Homebrew normally:

```bash
brew update && brew upgrade siberia
```

Maintainers can refresh the formula against the latest GitHub release with:

```bash
./scripts/update.siberia.sh
```

---

## Notes

- This formula installs from official Siberia GitHub release artifacts.
- The Homebrew tap metadata lives in `cavanaug/tap`, while the software itself is maintained in the upstream Siberia repository.
