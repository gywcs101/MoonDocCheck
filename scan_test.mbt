///|
test "scan MoonBit source detects documented and missing public APIs" {
  let source =
    #|/// Adds two numbers.
    #|pub fn add(a : Int, b : Int) -> Int {
    #|  a + b
    #|}
    #|
    #|pub struct MissingDoc {
    #|  value : Int
    #|}
    #|
  let items = scan_moon_source("sample.mbt", source)
  inspect(items.length(), content="2")
  inspect(items[0].documented, content="true")
  inspect(items[1].documented, content="false")
}

///|
test "scan Markdown counts checkable MoonBit examples" {
  let source =
    #|# Example
    #|
    #|```mbt check
    #|test { inspect(1, content="1") }
    #|```
    #|
    #|```moonbit
    #|let x = 1
    #|```
    #|
  let stats = scan_markdown_text(source)
  inspect(stats.code_blocks, content="2")
  inspect(stats.mbt_check_blocks, content="1")
  inspect(stats.moonbit_blocks, content="1")
}

///|
test "scan moon.mod detects core metadata fields" {
  let source =
    #|name = "user/project"
    #|version = "0.1.0"
    #|license = "MIT"
    #|description = "demo"
    #|
  let stats = scan_moon_mod_text(source)
  inspect(stats.has_name, content="true")
  inspect(stats.has_repository, content="false")
}

///|
test "render report includes missing documentation issue" {
  let items = scan_moon_source("sample.mbt", "pub fn missing() -> Unit { () }")
  let report = report_from_api_items("demo", items)
  let text = render_text(report)
  assert_true(text.contains("Missing documentation"))
}

///|
test "weak documentation is detected" {
  let source =
    #|/// TODO
    #|pub struct WeakDoc {
    #|  value : Int
    #|}
    #|
  let items = scan_moon_source("weak.mbt", source)
  inspect(items[0].weak_doc, content="true")
}

///|
test "pub all declarations are detected" {
  let source =
    #|/// A public enum.
    #|pub(all) enum Mode {
    #|  A
    #|}
    #|
    #|/// A public struct.
    #|pub(all) struct Config {
    #|  enabled : Bool
    #|}
    #|
  let items = scan_moon_source("puball.mbt", source)
  inspect(items.length(), content="2")
  inspect(items[0].kind, content="enum")
  inspect(items[1].kind, content="struct")
}

///|
test "readme scanner detects usage and development commands" {
  let source =
    #|# Demo
    #|
    #|## Usage
    #|
    #|```bash
    #|moon run cmd/main
    #|```
    #|
    #|## Development
    #|
    #|moon check
    #|moon test
    #|
    #|## License
    #|
    #|MIT
    #|
  let stats = scan_readme_text(source)
  inspect(stats.has_usage, content="true")
  inspect(stats.has_development_commands, content="true")
  inspect(stats.has_license_mention, content="true")
}

///|
test "ci scanner detects moon commands" {
  let source =
    #|steps:
    #|  - run: moon check
    #|  - run: moon test
    #|  - run: moon run cmd/main -- scan .
    #|
  let stats = scan_ci_text(source)
  inspect(stats.has_moon_check, content="true")
  inspect(stats.has_moon_test, content="true")
  inspect(stats.has_moon_run, content="true")
}

///|
test "path filter ignores dependency caches" {
  assert_true(should_ignore_path(".mooncakes/moonbitlang/x"))
  assert_true(should_ignore_path(".git/objects"))
  assert_false(should_ignore_path("src/main.mbt"))
}

///|
test "file classifier recognizes key project files" {
  assert_true(is_moonbit_source_file("sample.mbt"))
  assert_false(is_moonbit_source_file("README.mbt.md"))
  assert_true(is_markdown_file("README.mbt.md"))
  assert_true(is_readme_file("README.md"))
  assert_true(is_github_workflow_file(".github/workflows/ci.yml"))
}

///|
test "markdown renderer includes summary table" {
  let report = report_from_api_items("demo", [])
  let markdown = render_markdown(report)
  assert_true(markdown.contains("# MoonDocCheck Report"))
  assert_true(markdown.contains("| Public APIs | 0 |"))
}
