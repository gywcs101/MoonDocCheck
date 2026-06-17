///|
fn join_path(base : String, child : String) -> String {
  @path.Path(base).join(@path.Path(child)).to_string()
}

///|
fn collect_files(path : String, files : Array[String]) -> Unit raise {
  if should_ignore_path(path) {
    ()
  } else if @fs.is_file(path) {
    files.push(path)
  } else if @fs.is_dir(path) {
    for child in @fs.read_dir(path) {
      collect_files(join_path(path, child), files)
    }
  }
}

///|
fn merge_markdown_stats(left : MarkdownStats, right : MarkdownStats) -> MarkdownStats {
  {
    files: left.files + right.files,
    code_blocks: left.code_blocks + right.code_blocks,
    mbt_check_blocks: left.mbt_check_blocks + right.mbt_check_blocks,
    mbt_nocheck_blocks: left.mbt_nocheck_blocks + right.mbt_nocheck_blocks,
    moonbit_blocks: left.moonbit_blocks + right.moonbit_blocks,
  }
}

///|
fn merge_ci_stats(left : CiStats, right : CiStats) -> CiStats {
  {
    workflow_files: left.workflow_files + right.workflow_files,
    has_moon_check: left.has_moon_check || right.has_moon_check,
    has_moon_test: left.has_moon_test || right.has_moon_test,
    has_moon_fmt: left.has_moon_fmt || right.has_moon_fmt,
    has_moon_info: left.has_moon_info || right.has_moon_info,
    has_moon_run: left.has_moon_run || right.has_moon_run,
  }
}

///|
fn missing_readme_stats() -> ReadmeStats {
  {
    found: false,
    has_overview: false,
    has_usage: false,
    has_code_example: false,
    has_development_commands: false,
    has_license_mention: false,
  }
}

///|
fn missing_moon_mod_stats() -> MoonModStats {
  {
    found: false,
    has_name: false,
    has_version: false,
    has_readme: false,
    has_repository: false,
    has_license: false,
    has_keywords: false,
    has_description: false,
  }
}

///|
fn empty_markdown_stats() -> MarkdownStats {
  {
    files: 0,
    code_blocks: 0,
    mbt_check_blocks: 0,
    mbt_nocheck_blocks: 0,
    moonbit_blocks: 0,
  }
}

///|
fn empty_ci_stats() -> CiStats {
  {
    workflow_files: 0,
    has_moon_check: false,
    has_moon_test: false,
    has_moon_fmt: false,
    has_moon_info: false,
    has_moon_run: false,
  }
}

///|
fn build_project_report(
  project_name : String,
  files_scanned : Int,
  moonbit_source_files : Int,
  api_items : Array[ApiItem],
  markdown : MarkdownStats,
  readme : ReadmeStats,
  moon_mod : MoonModStats,
  ci : CiStats,
  has_generated_mbti : Bool
) -> ProjectReport {
  let report = report_from_api_items(project_name, api_items)
  {
    ..report,
    files_scanned,
    moonbit_source_files,
    markdown,
    readme,
    moon_mod,
    ci,
    has_generated_mbti,
  }
}

///|
/// Scan a MoonBit project directory and build a documentation quality report.
pub fn scan_project(path : String) -> ProjectReport raise {
  let files : Array[String] = []
  collect_files(path, files)
  let api_items : Array[ApiItem] = []
  let mut markdown = empty_markdown_stats()
  let mut readme = missing_readme_stats()
  let mut moon_mod = missing_moon_mod_stats()
  let mut ci = empty_ci_stats()
  let mut moonbit_source_files = 0
  let mut has_generated_mbti = false

  for file in files {
    if is_moonbit_source_file(file) {
      moonbit_source_files += 1
      let source = @fs.read_file_to_string(file)
      api_items.append(scan_moon_source(file, source))
    } else if is_markdown_file(file) {
      let source = @fs.read_file_to_string(file)
      markdown = merge_markdown_stats(markdown, scan_markdown_text(source))
      if is_readme_file(file) {
        readme = scan_readme_text(source)
      }
    } else if file.has_suffix("moon.mod") {
      moon_mod = scan_moon_mod_text(@fs.read_file_to_string(file))
    } else if file.has_suffix("pkg.generated.mbti") {
      has_generated_mbti = true
    } else if is_github_workflow_file(file) {
      ci = merge_ci_stats(ci, scan_ci_text(@fs.read_file_to_string(file)))
    }
  }

  build_project_report(
    path,
    files.length(),
    moonbit_source_files,
    api_items,
    markdown,
    readme,
    moon_mod,
    ci,
    has_generated_mbti,
  )
}
