///|
fn is_fence(line : String) -> Bool {
  line.trim().to_owned().has_prefix("```")
}

///|
fn fence_label(line : String) -> String {
  let text = line.trim().to_owned()
  match text.strip_prefix("```") {
    Some(rest) => rest.to_owned().trim().to_owned().to_lower()
    None => ""
  }
}

///|
/// Scan Markdown text and count MoonBit-related code examples.
pub fn scan_markdown_text(source : String) -> MarkdownStats {
  let lines = source.split("\n").map(line => line.to_owned()).collect()
  let mut in_block = false
  let mut code_blocks = 0
  let mut mbt_check_blocks = 0
  let mut mbt_nocheck_blocks = 0
  let mut moonbit_blocks = 0
  for line in lines {
    if is_fence(line) {
      if in_block {
        in_block = false
      } else {
        in_block = true
        code_blocks += 1
        let label = fence_label(line)
        if label == "mbt check" {
          mbt_check_blocks += 1
        } else if label == "mbt nocheck" {
          mbt_nocheck_blocks += 1
        } else if label == "moonbit" || label == "mbt" {
          moonbit_blocks += 1
        }
      }
    }
  }
  {
    files: 1,
    code_blocks,
    mbt_check_blocks,
    mbt_nocheck_blocks,
    moonbit_blocks,
  }
}

///|
/// Scan README content for common open-source project sections.
pub fn scan_readme_text(source : String) -> ReadmeStats {
  let lower = source.to_lower()
  {
    found: true,
    has_overview: lower.contains("简介") || lower.contains("overview") || lower.contains("目标") || lower.contains("project"),
    has_usage: lower.contains("使用") || lower.contains("usage") || lower.contains("install") || lower.contains("安装"),
    has_code_example: lower.contains("```"),
    has_development_commands: lower.contains("moon check") || lower.contains("moon test") || lower.contains("开发"),
    has_license_mention: lower.contains("license") || lower.contains("许可证"),
  }
}
