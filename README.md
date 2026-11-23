# Multi-Language Sandbox — C++, Java, Python

A dev container template for coursework in three languages. Each language gets
its own folder, and **all files in a folder are compiled together**, so this
works for multi-file projects, not just single scripts.

## Getting started

1. Open this folder in VS Code and choose **Reopen in Container**
   (or Command Palette → **Dev Containers: Rebuild Container**).
2. Wait for the first build — it ends with `=== Ready. Press F5 to build and debug. ===`
3. Press **F5**, pick your language once, and VS Code remembers it from then on.

## Layout

```
cpp/        every .cpp compiled together  ->  build/cpp/app
java/       every .java compiled together ->  build/java/
python/     run from python/main.py
build/      generated output (git-ignored)
```

Add as many files and subfolders as you like inside `cpp/`, `java/` and
`python/` — the build globs recursively, so nothing needs reconfiguring.

## Running and debugging

| Action | How |
| --- | --- |
| **Debug** | `F5` → pick *Debug C++ / Debug Java / Debug Python* |
| **Build** | `Ctrl+Shift+B` (C++), or *Tasks: Run Task* → *Build All* |
| **Run without debugging** | *Tasks: Run Task* → *C++ / Java / Python: Run* |

Programs run in the integrated terminal, so `std::cin`, `Scanner` and
`input()` all work.

### Entry points

Each language has one entry point, by convention:

| Language | Entry point | Change it in |
| --- | --- | --- |
| C++ | `main()` in any file under `cpp/` | — |
| Java | `Main.main()` | `mainClass` in `.vscode/launch.json` |
| Python | `python/main.py` | `program` in `.vscode/launch.json` |

## About the single debug configuration

`.vscode/launch.json` has one entry per language rather than one shared entry.
This is a VS Code limitation, not an oversight: a configuration's `"type"`
selects the debug adapter *before* any `${...}` variable is resolved, so it
cannot depend on which file is open. Three adapters (`cppdbg`, `java`,
`debugpy`) means three entries.

In practice it behaves like one: `F5` remembers the last configuration per
workspace, so you choose once.

Builds *are* unified — **Build All** compiles C++ and Java in parallel from a
single task.

## What's installed

| Language | Tools |
| --- | --- |
| C++ | `g++` (GCC, `-std=c++17`), `make`, `gdb` |
| Java | OpenJDK 21 (`java`, `javac`, `jdb`) |
| Python | Python 3.12 (`python` and `python3`), `pip`, `venv` |

## Customising

- **C++ standard** — change `-std=c++17` in `.vscode/tasks.json` (two places:
  the build task, and `C_Cpp.default.cppStandard` in `settings.json`).
- **Python packages** — add them to `requirements.txt`, then rebuild the
  container or run `bash .devcontainer/setup.sh`.
- **Java libraries** — drop `.jar` files in a `lib/` folder; they are already
  on the classpath via `java.project.referencedLibraries`.
- **Copilot** — disabled in `.vscode/settings.json`. Delete that block to allow
  it. Note this is a workspace setting a student can change; only a GitHub
  organisation policy enforces it.

## Notes

- Line endings are forced to LF by `.gitattributes`. CRLF breaks shell scripts
  inside the Linux container, so don't convert `.devcontainer/setup.sh`.
- `build/` is hidden from the Explorer and git-ignored; delete it any time.
