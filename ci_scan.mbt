///|
/// Scan workflow text for common MoonBit validation commands.
pub fn scan_ci_text(source : String) -> CiStats {
  let lower = source.to_lower()
  {
    workflow_files: 1,
    has_moon_check: lower.contains("moon check"),
    has_moon_test: lower.contains("moon test"),
    has_moon_fmt: lower.contains("moon fmt"),
    has_moon_info: lower.contains("moon info"),
    has_moon_run: lower.contains("moon run"),
  }
}

