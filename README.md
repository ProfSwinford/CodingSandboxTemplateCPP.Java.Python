# Multi-Language Sandbox — C++, Java, Python

A dev container template for coursework in three languages. Each language has
its own folder, and **every file in a folder is compiled together**, so this
suits multi-file projects, not just single scripts.

This file is for you, the instructor. Students read `student/README.md`.

## Layout

```
.devcontainer/        image + setup (students never see this)
  Dockerfile
  devcontainer.json
  setup.sh
student/              <- the editor opens HERE
  .vscode/            tasks, launch, settings  (hidden from students)
  cpp/                every .cpp compiled together -> student/build/cpp/app
  java/               every .java compiled together -> student/build/java/
  python/             entry point main.py
  README.md           student-facing instructions
.vscode/              fallback only (see below)
requirements.txt      optional Python packages
```

`workspaceFolder` in `.devcontainer/devcontainer.json` points the editor at
`student/`, so students cannot navigate above it and never see
`.devcontainer`, `.git` or the repo-level files. Inside `student/` they see
four things: `cpp/`, `java/`, `python/` and `README.md`.

Add files and subfolders freely inside the language folders — the builds glob
recursively, so nothing needs reconfiguring.

## Getting started

1. Push this repo to GitHub and mark it as a template.
2. **Use this template → Open in a Codespace.**
3. The first build ends with `=== Ready. Press F5 to build and debug. ===`
4. Press **F5**, pick a language once, and VS Code remembers it.

## Running and debugging

| Action | How |
| --- | --- |
| **Debug** | `F5` → pick *Debug C++ / Debug Java / Debug Python* |
| **Build** | `Ctrl+Shift+B` (C++), or *Tasks: Run Task* → *Build All* |
| **Run without debugging** | *Tasks: Run Task* → *C++ / Java / Python: Run* |

Programs run in the integrated terminal, so `std::cin`, `Scanner` and
`input()` all work.

### Entry points

| Language | Entry point | Change it in |
| --- | --- | --- |
| C++ | `main()` in any file under `student/cpp/` | — |
| Java | `Main.main()` | `mainClass` in `student/.vscode/launch.json` |
| Python | `student/python/main.py` | `program` in `student/.vscode/launch.json` |

### Why three debug configurations

`student/.vscode/launch.json` has one entry per language rather than one shared
entry. This is a VS Code limitation, not an oversight: a configuration's
`"type"` selects the debug adapter *before* any `${...}` variable is resolved,
so it cannot depend on which file is open. Three adapters (`cppdbg`, `java`,
`debugpy`) means three entries.

In practice it behaves like one — `F5` remembers the last choice per workspace.
Builds *are* unified: **Build All** compiles C++ and Java in parallel from a
single task.

## Verify the deeper root before handing this out

`workspaceFolder` uses `${localWorkspaceFolderBasename}`, which the dev
container spec defines but which is **not** documented as supported in GitHub
Codespaces. If it fails to substitute, the editor tries to open a literal
`/workspaces/${localWorkspaceFolderBasename}/student`, which does not exist.
Hardcoding the repo name is not a workaround, because "Use this template" gives
every student repo a different name.

**Signs it worked:** the Explorer title says `STUDENT`, and `pwd` in a new
terminal ends in `/student`.

### If it does not work

Revert to a flat layout:

1. Delete the root `.vscode/settings.json`.
2. Move `student/cpp`, `student/java`, `student/python` and `student/.vscode`
   up to the repo root.
3. In `.devcontainer/devcontainer.json`, delete the `workspaceFolder` line and
   change `onCreateCommand` back to `.devcontainer/setup.sh` (drop the `../`).
4. Add the structural paths to `files.exclude` in the now-root
   `.vscode/settings.json`:
   `**/.devcontainer`, `**/.vscode`, `**/.git`, `**/.gitattributes`,
   `**/.gitignore`, `**/requirements.txt`, `build`

That gives the same clean Explorer, just without confinement.

### The root .vscode/ folder

It contains `files.exclude` only — not a second copy of the build and debug
setup. If `workspaceFolder` works it is never read. It exists so that if the
variable fails and the editor falls back to the repo root, students still get a
clean Explorer showing only `student/`. Build and debug configuration lives in
exactly one place, `student/.vscode`, so there is no second copy to keep in sync.

## Blocking AI assistance

`student/.vscode/settings.json` turns off Copilot completions, Copilot Chat,
inline chat and agent mode. `chat.disableAIFeatures` is the switch that removes
the chat view in current VS Code; the `github.copilot.*` keys cover older
builds. `student/.vscode/extensions.json` also marks the Copilot extensions as
unwanted.

**This is a deterrent, not enforcement.** These are workspace settings in a
file the student can edit, and if their account has a Copilot licence the
extension may still arrive via Settings Sync. The only hard control is a
**GitHub organisation Copilot policy** — set that if academic integrity
depends on it.

## What's installed

| Language | Tools |
| --- | --- |
| C++ | `g++` (GCC, `-std=c++17`), `make`, `gdb` |
| Java | OpenJDK 21 (`java`, `javac`, `jdb`) |
| Python | Python 3.12 (`python` and `python3`), `pip`, `venv` |

`.devcontainer/setup.sh` also acts as a safety net: if the image was not built
from the Dockerfile, it installs any missing toolchain and extension at
container creation, and reports which case applied.

## Customising

- **C++ standard** — change `-std=c++17` in `student/.vscode/tasks.json` and
  `C_Cpp.default.cppStandard` in `student/.vscode/settings.json`.
- **Python packages** — add them to `requirements.txt` (repo root or
  `student/`; `setup.sh` checks both), then rebuild or run
  `bash .devcontainer/setup.sh`.
- **Java libraries** — drop `.jar` files in `student/lib/`; they are already on
  the classpath via `java.project.referencedLibraries`.
- **Allow AI** — delete the AI block from `student/.vscode/settings.json`.

## Notes

- Line endings are forced to LF by `.gitattributes`. CRLF breaks shell scripts
  inside the Linux container, so don't convert `.devcontainer/setup.sh`.
- `student/build/` is hidden from the Explorer and git-ignored.
- Java requires the class name to match the file name, and `Main.java` must
  contain `public class Main` for `F5` to resolve it.
