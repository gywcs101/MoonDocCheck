///|
fn has_moon_mod_field(source : String, field : String) -> Bool {
  for line in source.split("\n") {
    let text = line.to_owned().trim().to_owned()
    if text.has_prefix(field + " ") || text.has_prefix(field + "=") {
      return true
    }
  }
  false
}

///|
/// Scan a `moon.mod` file for package metadata used by MoonBit package reviewers.
pub fn scan_moon_mod_text(source : String) -> MoonModStats {
  {
    found: true,
    has_name: has_moon_mod_field(source, "name"),
    has_version: has_moon_mod_field(source, "version"),
    has_readme: has_moon_mod_field(source, "readme"),
    has_repository: has_moon_mod_field(source, "repository"),
    has_license: has_moon_mod_field(source, "license"),
    has_keywords: has_moon_mod_field(source, "keywords"),
    has_description: has_moon_mod_field(source, "description"),
  }
}
