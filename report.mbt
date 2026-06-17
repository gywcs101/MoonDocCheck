///|
fn coverage_percent(total : Int, documented : Int) -> Int {
  if total == 0 {
    100
  } else {
    documented * 100 / total
  }
}

///|
/// Build a minimal report from source-level scan results.
pub fn report_from_api_items(
  project_name : String,
  items : Array[ApiItem],
) -> ProjectReport {
  let mut documented = 0
  let issues : Array[DocIssue] = []
  for item in items {
    if item.documented {
      documented += 1
      if item.weak_doc {
        issues.push({
          severity: Warning,
          file: item.file,
          line: Some(item.line),
          message: "Weak documentation for public API `" + item.name + "`",
        })
      }
    } else {
      issues.push({
        severity: Warning,
        file: item.file,
        line: Some(item.line),
        message: "Missing documentation for public API `" + item.name + "`",
      })
    }
  }
  let total = items.length()
  {
    project_name,
    files_scanned: 0,
    moonbit_source_files: 0,
    public_api_total: total,
    public_api_documented: documented,
    public_api_missing_docs: total - documented,
    documentation_coverage: coverage_percent(total, documented),
    api_items: items,
    markdown: {
      files: 0,
      code_blocks: 0,
      mbt_check_blocks: 0,
      mbt_nocheck_blocks: 0,
      moonbit_blocks: 0,
    },
    readme: {
      found: false,
      has_overview: false,
      has_usage: false,
      has_code_example: false,
      has_development_commands: false,
      has_license_mention: false,
    },
    moon_mod: {
      found: false,
      has_name: false,
      has_version: false,
      has_readme: false,
      has_repository: false,
      has_license: false,
      has_keywords: false,
      has_description: false,
    },
    ci: {
      workflow_files: 0,
      has_moon_check: false,
      has_moon_test: false,
      has_moon_fmt: false,
      has_moon_info: false,
      has_moon_run: false,
    },
    has_generated_mbti: false,
    issues,
  }
}
