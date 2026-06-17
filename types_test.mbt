///|
test "project metadata helpers" {
  inspect(project_name(), content="MoonDocCheck")
  inspect(version(), content="0.1.0")
}
