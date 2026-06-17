///|
fn path_contains_segment(path : String, segment : String) -> Bool {
  path.contains("/" + segment + "/") ||
  path.contains("\\" + segment + "\\") ||
  path.has_prefix(segment + "/") ||
  path.has_prefix(segment + "\\") ||
  path.has_suffix("/" + segment) ||
  path.has_suffix("\\" + segment) ||
  path == segment
}

///|
/// Return true when a path should be ignored during project scanning.
pub fn should_ignore_path(path : String) -> Bool {
  path_contains_segment(path, ".git") ||
  path_contains_segment(path, ".moon") ||
  path_contains_segment(path, ".mooncakes") ||
  path_contains_segment(path, ".repos") ||
  path_contains_segment(path, "target") ||
  path_contains_segment(path, "build") ||
  path_contains_segment(path, "_build") ||
  path.contains(".analysis_")
}

///|
/// Return true when a path matches a user-provided exclusion pattern.
pub fn matches_exclusion(path : String, pattern : String) -> Bool {
  pattern != "" &&
  (path_contains_segment(path, pattern) || path.contains(pattern))
}

///|
/// Return true when a path should be ignored by default rules or custom exclusions.
pub fn should_ignore_path_with_exclusions(
  path : String,
  exclusions : Array[String],
) -> Bool {
  if should_ignore_path(path) {
    true
  } else {
    for pattern in exclusions {
      if matches_exclusion(path, pattern) {
        return true
      }
    }
    false
  }
}
