# ghpr

Commit, push, and open a GitHub pull request from the terminal.

## Install

```bash
./install.sh
```

Install to a user-local bin directory:

```bash
INSTALL_DIR="$HOME/.local/bin" ./install.sh
```

## Uninstall

```bash
./uninstall.sh
```

## Usage

```bash
ghpr --help
ghpr --version
```

## Automatic Updates

When you run ghpr, it automatically checks if a newer version is available by comparing your current version against the latest git tag. If an update is available, ghpr will prompt you:

```
📦 A new version of ghpr is available: 0.2.1 (current: 0.2.0)
   Run 'ghpr-update' to upgrade? [y/N]
```

If you accept, ghpr runs `update.sh` automatically. You can also update manually with `./update.sh`.

## Versioning and Updates

This project uses Semantic Versioning in the `VERSION` file:

- `MAJOR`: breaking changes
- `MINOR`: backward-compatible features
- `PATCH`: backward-compatible fixes

`install.sh` stamps the current version into the installed `ghpr` binary and reports installs/updates.

Check installed version:

```bash
ghpr --version
```

Update an existing install:

```bash
./update.sh
```

Or manually:

```bash
git pull origin main
./install.sh
```

This safely updates users already on older versions.

## Recommended release flow

1. Update code and test.
2. Bump `VERSION` (`PATCH`, `MINOR`, or `MAJOR`):

```bash
echo "0.2.1" > VERSION
```

3. Use ghpr itself to commit and push the version bump:

```bash
ghpr -m "release: v0.2.1" --no-pr
```

4. Tag the release:

```bash
git tag v0.2.1
git push origin main --tags
```

Users can then run `./update.sh` to fetch and install the new release.
