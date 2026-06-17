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
