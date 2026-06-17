///|
/// Render a project report as machine-readable JSON.
pub fn render_json(report : ProjectReport, indent? : Int = 2) -> String {
  report.to_json().stringify(indent~)
}
