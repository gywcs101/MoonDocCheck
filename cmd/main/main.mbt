///|
fn usage() -> Unit {
  println("\{@moondoccheck.project_name()} \{@moondoccheck.version()}")
  println(
    "Usage: moon run cmd/main -- scan <path> [--format text|markdown|json] [--output file]",
  )
}

///|
fn arg_value(args : Array[String], name : String) -> String? {
  for index, arg in args {
    if arg == name && index + 1 < args.length() {
      return Some(args[index + 1])
    }
  }
  None
}

///|
fn render_for_format(
  report : @moondoccheck.ProjectReport,
  format : String,
) -> String {
  if format == "markdown" {
    @moondoccheck.render_markdown(report)
  } else if format == "json" {
    @moondoccheck.render_json(report)
  } else {
    @moondoccheck.render_text(report)
  }
}

///|
fn main raise {
  let args = @env.args()
  if args.length() >= 3 && args[1] == "scan" {
    let report = @moondoccheck.scan_project(args[2])
    let format = arg_value(args, "--format").unwrap_or("text")
    let output = render_for_format(report, format)
    match arg_value(args, "--output") {
      Some(path) => @fs.write_string_to_file(path, output)
      None => println(output)
    }
  } else {
    usage()
  }
}
