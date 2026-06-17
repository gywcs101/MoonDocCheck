# MoonDocCheck

MoonDocCheck is a lightweight documentation quality checker for MoonBit projects.

It helps maintainers quickly answer a simple question before publishing or reviewing a package:

> Is this MoonBit project documented well enough for others to understand and use?

MoonDocCheck scans source files, README files, package metadata, generated interface summaries, and CI workflows, then produces a clear report with actionable documentation issues.

## What It Checks

- Public MoonBit APIs without `///` documentation comments.
- Weak placeholder documentation such as `TODO` or `FIXME`.
- Project-level and file-level documentation coverage.
- README readiness, including usage examples and development commands.
- Markdown MoonBit examples, including `mbt check` and `mbt nocheck` blocks.
- `moon.mod` metadata such as description, license, repository, and keywords.
- Generated interface summaries from `moon info`.
- GitHub Actions usage of common MoonBit validation commands.

## Usage

Scan a project and print a terminal report:

```bash
moon run cmd/main -- scan .
```

Write a Markdown report:

```bash
moon run cmd/main -- scan . --format markdown --output DOC_REPORT.md
```

Write a JSON report:

```bash
moon run cmd/main -- scan . --format json --output doc-report.json
```

Exclude generated or vendored paths:

```bash
moon run cmd/main -- scan . --exclude vendor --exclude generated
```

## Example

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

Issues:
  - examples/missing_docs/sample.mbt:8 Missing documentation for public API `missing_doc`
  - examples/missing_docs/sample.mbt:14 Weak documentation for public API `WeakDoc`
```

## Development

Run checks:

```bash
moon check
moon test
moon info
```

Try the included examples:

```bash
moon run cmd/main -- scan examples/good_project
moon run cmd/main -- scan examples/missing_docs
moon run cmd/main -- scan examples/readme_gaps
```

## Roadmap

- Improve parsing for complex multi-line public declarations.
- Add configurable rule levels and CI thresholds.
- Provide richer Markdown and JSON report summaries.
- Add more checks for MoonBit documentation conventions.
- Publish the package to mooncakes.io.

## License

This project is licensed under the MIT License.
