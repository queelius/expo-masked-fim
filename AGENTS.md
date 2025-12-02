# Repository Guidelines

## Project Structure & Module Organization
- `paper/`: primary LaTeX sources (`main.tex`, `references.bib`) and compiled artifacts in `html/` (PDF, CSS, HTML preview).
- `figures/`: TeX snippets and rendered assets used in the paper; compile before inclusion to keep PDFs in sync.
- `img/`: TikZ/diagram sources for figures.
- `research/`: data, C++ prototype (`matrix_errors.cpp`), and gnuplot scripts for error plots; regenerate figures/data here before updating the paper.
- `archive/`: deprecated drafts and notes; read-only unless explicitly reviving material.

## Build, Test, and Development Commands
- `cd paper && latexmk -pdf main.tex`: build the paper PDF into `paper/main.pdf` (reruns bib/refs automatically).
- `cd paper && latexmk -c`: clean auxiliary LaTeX build outputs.
- `cd paper/html && latexmlc ../main.tex --dest=index.html`: regenerate the HTML preview (mirrors the current PDF).
- `g++ -std=c++17 -O2 research/matrix_errors/matrix_errors.cpp -o /tmp/matrix_errors && /tmp/matrix_errors`: recompute error data; outputs to `research/matrix_errors/*.dat`.
- `gnuplot research/matrix_errors/errors.plt`: regenerate error plots used in figures.

## Coding Style & Naming Conventions
- LaTeX: prefer clear, descriptive labels (`\label{fig:masked-error}`), keep environments indented for readability, and group macros near the preamble.
- Figures/assets: use `fig_<topic>_<detail>.tex/png` naming to match existing patterns.
- Bibliography: add entries to `paper/references.bib` and cite with `\cite{key}`; avoid ad-hoc inline URLs.
- C++/scripts: follow existing minimal style; keep functions short and comment non-obvious math steps.

## Testing Guidelines
- Run `latexmk -pdf` before pushing to catch compilation or reference errors; check the log for warnings about undefined refs/cites.
- After regenerating data or plots, open the resulting PDFs/PNGs to confirm axes, labels, and units remain correct.
- No automated unit tests exist; rely on clean builds and visually verifying regenerated figures.

## Commit & Pull Request Guidelines
- Commit messages: short, present-tense subjects (e.g., `update figures`, `refine latex refs`), mirroring existing history.
- Include regenerated artifacts (`paper/main.pdf`, `paper/html/index.html`, updated plots) when relevant and note them in the commit/PR description.
- PRs should summarize sections changed, link any tracking issue, and, when modifying figures/data, mention the commands used to regenerate outputs.
- Attach screenshots or PDFs for visual changes to figures so reviewers can compare quickly.
