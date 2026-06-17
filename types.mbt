///|
/// User-configurable options for a project scan.
pub(all) struct ScanOptions {
  exclusions : Array[String]
} derive(Debug, Eq, ToJson)

///|
/// Severity of a documentation or project readiness issue.
pub(all) enum Severity {
  Error
  Warning
  Suggestion
} derive(Debug, Eq, ToJson)

///|
/// A public API item discovered in a MoonBit source file.
pub(all) struct ApiItem {
  name : String
  kind : String
  file : String
  line : Int
  documented : Bool
  weak_doc : Bool
} derive(Debug, Eq, ToJson)

///|
/// A single issue found while scanning a MoonBit project.
pub(all) struct DocIssue {
  severity : Severity
  file : String
  line : Int?
  message : String
} derive(Debug, Eq, ToJson)

///|
/// Summary of Markdown code examples found in project documentation.
pub(all) struct MarkdownStats {
  files : Int
  code_blocks : Int
  mbt_check_blocks : Int
  mbt_nocheck_blocks : Int
  moonbit_blocks : Int
} derive(Debug, Eq, ToJson)

///|
/// Summary of README-related signals.
pub(all) struct ReadmeStats {
  found : Bool
  has_overview : Bool
  has_usage : Bool
  has_code_example : Bool
  has_development_commands : Bool
  has_license_mention : Bool
} derive(Debug, Eq, ToJson)

///|
/// Summary of MoonBit module metadata found in `moon.mod`.
pub(all) struct MoonModStats {
  found : Bool
  has_name : Bool
  has_version : Bool
  has_readme : Bool
  has_repository : Bool
  has_license : Bool
  has_keywords : Bool
  has_description : Bool
} derive(Debug, Eq, ToJson)

///|
/// Summary of CI workflow readiness signals.
pub(all) struct CiStats {
  workflow_files : Int
  has_moon_check : Bool
  has_moon_test : Bool
  has_moon_fmt : Bool
  has_moon_info : Bool
  has_moon_run : Bool
} derive(Debug, Eq, ToJson)

///|
/// Full scan report for a MoonBit repository.
pub(all) struct ProjectReport {
  project_name : String
  files_scanned : Int
  moonbit_source_files : Int
  public_api_total : Int
  public_api_documented : Int
  public_api_missing_docs : Int
  documentation_coverage : Int
  api_items : Array[ApiItem]
  markdown : MarkdownStats
  readme : ReadmeStats
  moon_mod : MoonModStats
  ci : CiStats
  has_generated_mbti : Bool
  issues : Array[DocIssue]
} derive(Debug, Eq, ToJson)
