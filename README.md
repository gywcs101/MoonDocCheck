# MoonDocCheck

MoonDocCheck is a documentation quality checker for MoonBit projects. It scans a MoonBit repository and reports whether the project has the documentation, examples, package metadata, generated API summaries, and CI signals expected from a maintainable open-source package.

MoonDocCheck does not replace MoonBit's official documentation tools. It works alongside existing MoonBit features such as doc comments, `README.mbt.md` checkable examples, `moon info`, and `moon ide doc`.

## Goals

- Detect public MoonBit APIs that do not have doc comments.
- Warn about weak doc comments such as `TODO`, `FIXME`, or very short placeholder text.
- Check whether a README exists and contains common open-source project sections.
- Count checkable documentation examples written as `mbt check` code blocks.
- Check whether `moon.mod` contains useful package metadata.
- Check whether `pkg.generated.mbti` files exist.
- Check whether GitHub Actions run `moon check` and `moon test`.
- Produce terminal and Markdown reports that are easy to review.

## Usage

Scan a MoonBit project and print a terminal report:

```bash
moon run cmd/main -- scan .
```

Scan a project and write a Markdown report:

```bash
moon run cmd/main -- scan . --format markdown --output DOC_REPORT.md
```

Scan an example project:

```bash
moon run cmd/main -- scan examples/missing_docs
```

Example output:

```text
MoonDocCheck Report

Project: examples/missing_docs
Files scanned: 4
MoonBit source files: 1

Public API documentation:
  Total: 3
  Documented: 2
  Missing: 1
  Coverage: 66%

README:
  Found: yes
  Has usage: yes
  Has code example: yes

Examples:
  mbt check blocks: 0
  ordinary MoonBit blocks: 1

CI:
  GitHub Actions files: 0
  moon check: no
  moon test: no

Issues:
  - examples/missing_docs/sample.mbt:8 Missing documentation for public API `missing_doc`
  - examples/missing_docs/sample.mbt:14 Weak documentation for public API `WeakDoc`
```

## Current Features

MoonDocCheck currently supports:

- Recursive project scanning.
- Ignoring common generated or dependency directories such as `.git`, `.moon`, `.mooncakes`, `.repos`, `_build`, `target`, and `build`.
- Public API extraction from `.mbt` files.
- Detection for common public declarations:
  - `pub fn`
  - `pub struct`
  - `pub enum`
  - `pub type`
  - `pub trait`
  - `pub suberror`
  - `pub(all) struct`
  - `pub(all) enum`
  - `declare pub`
- Matching public APIs with nearby `///` documentation comments.
- Weak documentation warnings.
- README detection.
- Markdown code block counting.
- `mbt check`, `mbt nocheck`, and ordinary MoonBit code block statistics.
- Lightweight `moon.mod` metadata checks.
- `pkg.generated.mbti` existence checks.
- GitHub Actions command checks.
- Terminal report output.
- Markdown report output.
- Example projects for good and problematic documentation states.

## Non-Goals

MoonDocCheck intentionally does not try to:

- Implement a complete MoonBit parser.
- Replace MoonBit's official documentation system.
- Perform full semantic analysis across packages.
- Rewrite user source files automatically.
- Make strict natural-language judgments about README quality.
- Guarantee that ordinary display-only code blocks compile.

## Project Layout

Key files:

- `moon_source_scan.mbt`: scans MoonBit source files and extracts public APIs.
- `markdown_scan.mbt`: scans Markdown files and counts documentation examples.
- `moon_mod_scan.mbt`: checks package metadata in `moon.mod`.
- `ci_scan.mbt`: checks GitHub Actions workflow text.
- `project_scan.mbt`: coordinates project-level scanning.
- `report.mbt`: builds project reports.
- `render_text.mbt`: renders terminal reports.
- `render_markdown.mbt`: renders Markdown reports.
- `cmd/main/main.mbt`: command-line entry point.
- `examples/`: small fixture projects used to demonstrate scanner output.

## Development

Run checks:

```bash
moon check
```

Run tests:

```bash
moon test
```

Generate interface summaries:

```bash
moon info
```

Run the CLI locally:

```bash
moon run cmd/main -- scan examples/good_project
moon run cmd/main -- scan examples/missing_docs
```

## Roadmap

Planned improvements before the first stable release:

- Add JSON report output.
- Add configurable scan rules and ignore paths.
- Improve multi-line public declaration detection.
- Add file-level documentation coverage summaries.
- Add CI mode with coverage thresholds and non-zero exit codes.
- Add safer report-generation helpers without modifying source files.
- Publish the package to mooncakes.io.

## License

This project is licensed under the MIT License.
