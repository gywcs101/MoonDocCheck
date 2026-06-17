///|
/// Classify whether a file path points to a MoonBit source file.
pub fn is_moonbit_source_file(path : String) -> Bool {
  path.has_suffix(".mbt") && !path.has_suffix(".mbt.md")
}

///|
/// Classify whether a file path points to Markdown documentation.
pub fn is_markdown_file(path : String) -> Bool {
  path.has_suffix(".md") || path.has_suffix(".mbt.md")
}

///|
/// Classify README files accepted by MoonDocCheck.
pub fn is_readme_file(path : String) -> Bool {
  path.has_suffix("README.md") || path.has_suffix("README.mbt.md")
}

///|
/// Classify GitHub Actions workflow files.
pub fn is_github_workflow_file(path : String) -> Bool {
  (path.contains(".github/workflows/") || path.contains(".github\\workflows\\")) &&
  (path.has_suffix(".yml") || path.has_suffix(".yaml"))
}
