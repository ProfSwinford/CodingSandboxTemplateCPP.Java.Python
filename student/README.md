# Your Sandbox

Three languages, ready to go. Put your code in the matching folder.

| Folder | Language | Entry point |
| --- | --- | --- |
| `cpp/` | C++ | `main()` in any file |
| `java/` | Java | `Main.main()` in `Main.java` |
| `python/` | Python | `main.py` |

## Running your code

| Action | How |
| --- | --- |
| **Debug** (breakpoints) | `F5`, then pick your language the first time |
| **Build** | `Ctrl+Shift+B` |
| **Run without debugging** | **Terminal → Run Task** → *C++ / Java / Python: Run* |

Programs run in the terminal panel, so `std::cin`, `Scanner` and `input()`
all work normally.

## Multiple files

Every file in a folder is compiled together, including subfolders — so you can
split your work across as many files as you like. Add `cpp/matrix.cpp`,
`java/Deck.java`, `python/solver.py`, and they are picked up automatically with
no setup.

The examples show this: each language has a `main` plus a separate `greeter`
module that it calls.

## Notes

- Java needs the class name to match the file name, and `Main.java` must
  contain `public class Main` for `F5` to find it.
- Compiled output goes to a hidden `build/` folder. You can ignore it.
- If VS Code asks whether to allow automatic tasks, choose **Allow**.
