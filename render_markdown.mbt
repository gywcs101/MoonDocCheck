///|
/// Render a project report as Markdown.
pub fn render_markdown(report : ProjectReport) -> String {
  let lines : Array[String] = []
  lines.push("# MoonDocCheck Report")
  lines.push("")
  lines.push("## Summary")
  lines.push("")
  lines.push("| Item | Value |")
  lines.push("|---|---:|")
  lines.push("| Files scanned | " + report.files_scanned.to_string() + " |")
  lines.push("| MoonBit source files | " + report.moonbit_source_files.to_string() + " |")
  lines.push("| Public APIs | " + report.public_api_total.to_string() + " |")
  lines.push("| Documented APIs | " + report.public_api_documented.to_string() + " |")
  lines.push("| Missing docs | " + report.public_api_missing_docs.to_string() + " |")
  lines.push("| Documentation coverage | " + report.documentation_coverage.to_string() + "% |")
  lines.push("")
  lines.push("## README")
  lines.push("")
  lines.push("- Found: " + yes_no(report.readme.found))
  lines.push("- Has usage: " + yes_no(report.readme.has_usage))
  lines.push("- Has code example: " + yes_no(report.readme.has_code_example))
  lines.push("- Has development commands: " + yes_no(report.readme.has_development_commands))
  lines.push("- Has license mention: " + yes_no(report.readme.has_license_mention))
  lines.push("")
  lines.push("## Examples")
  lines.push("")
  lines.push("- Code blocks: " + report.markdown.code_blocks.to_string())
  lines.push("- `mbt check` blocks: " + report.markdown.mbt_check_blocks.to_string())
  lines.push("- `mbt nocheck` blocks: " + report.markdown.mbt_nocheck_blocks.to_string())
  lines.push("- Ordinary MoonBit blocks: " + report.markdown.moonbit_blocks.to_string())
  lines.push("")
  lines.push("## CI")
  lines.push("")
  lines.push("- Workflow files: " + report.ci.workflow_files.to_string())
  lines.push("- `moon check`: " + yes_no(report.ci.has_moon_check))
  lines.push("- `moon test`: " + yes_no(report.ci.has_moon_test))
  lines.push("- `moon fmt`: " + yes_no(report.ci.has_moon_fmt))
  lines.push("- `moon info`: " + yes_no(report.ci.has_moon_info))
  lines.push("")
  lines.push("## Issues")
  lines.push("")
  if report.issues.is_empty() {
    lines.push("No issues found.")
  } else {
    for issue in report.issues {
      let location = match issue.line {
        Some(line) => issue.file + ":" + line.to_string()
        None => issue.file
      }
      lines.push("- `" + location + "` " + issue.message)
    }
  }
  lines.join("\n")
}

