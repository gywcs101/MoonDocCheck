///|
fn yes_no(value : Bool) -> String {
  if value {
    "yes"
  } else {
    "no"
  }
}

///|
/// Render a project report as terminal-friendly text.
pub fn render_text(report : ProjectReport) -> String {
  let lines : Array[String] = []
  lines.push("MoonDocCheck Report")
  lines.push("")
  lines.push("Project: " + report.project_name)
  lines.push("Files scanned: " + report.files_scanned.to_string())
  lines.push("MoonBit source files: " + report.moonbit_source_files.to_string())
  lines.push("")
  lines.push("Public API documentation:")
  lines.push("  Total: " + report.public_api_total.to_string())
  lines.push("  Documented: " + report.public_api_documented.to_string())
  lines.push("  Missing: " + report.public_api_missing_docs.to_string())
  lines.push("  Coverage: " + report.documentation_coverage.to_string() + "%")
  if !report.file_coverage.is_empty() {
    lines.push("")
    lines.push("File coverage:")
    for summary in report.file_coverage {
      lines.push(
        "  - " +
        summary.file +
        ": " +
        summary.public_api_documented.to_string() +
        "/" +
        summary.public_api_total.to_string() +
        " documented (" +
        summary.documentation_coverage.to_string() +
        "%)",
      )
    }
  }
  lines.push("")
  lines.push("README:")
  lines.push("  Found: " + yes_no(report.readme.found))
  lines.push("  Has usage: " + yes_no(report.readme.has_usage))
  lines.push("  Has code example: " + yes_no(report.readme.has_code_example))
  lines.push("")
  lines.push("Examples:")
  lines.push(
    "  mbt check blocks: " + report.markdown.mbt_check_blocks.to_string(),
  )
  lines.push(
    "  ordinary MoonBit blocks: " + report.markdown.moonbit_blocks.to_string(),
  )
  lines.push("")
  lines.push("CI:")
  lines.push("  GitHub Actions files: " + report.ci.workflow_files.to_string())
  lines.push("  moon check: " + yes_no(report.ci.has_moon_check))
  lines.push("  moon test: " + yes_no(report.ci.has_moon_test))
  if !report.issues.is_empty() {
    lines.push("")
    lines.push("Issues:")
    let limit = if report.issues.length() > 20 {
      20
    } else {
      report.issues.length()
    }
    for index in 0..<limit {
      let issue = report.issues[index]
      let location = match issue.line {
        Some(line) => issue.file + ":" + line.to_string()
        None => issue.file
      }
      lines.push("  - " + location + " " + issue.message)
    }
    if report.issues.length() > limit {
      lines.push(
        "  ... " + (report.issues.length() - limit).to_string() + " more issues",
      )
    }
  }
  lines.join("\n")
}
