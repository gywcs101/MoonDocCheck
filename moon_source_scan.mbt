///|
fn is_public_declaration(line : String) -> Bool {
  let text = line.trim().to_owned()
  text.has_prefix("pub fn ") ||
  text.has_prefix("pub struct ") ||
  text.has_prefix("pub enum ") ||
  text.has_prefix("pub type ") ||
  text.has_prefix("pub trait ") ||
  text.has_prefix("pub suberror ") ||
  text.has_prefix("pub(all) struct ") ||
  text.has_prefix("pub(all) enum ") ||
  text.has_prefix("declare pub ")
}

///|
fn declaration_kind(line : String) -> String {
  let text = line.trim().to_owned()
  if text.has_prefix("pub fn ") {
    "function"
  } else if text.has_prefix("pub struct ") ||
    text.has_prefix("pub(all) struct ") {
    "struct"
  } else if text.has_prefix("pub enum ") || text.has_prefix("pub(all) enum ") {
    "enum"
  } else if text.has_prefix("pub type ") {
    "type"
  } else if text.has_prefix("pub trait ") {
    "trait"
  } else if text.has_prefix("pub suberror ") {
    "suberror"
  } else if text.has_prefix("declare pub ") {
    "declaration"
  } else {
    "unknown"
  }
}

///|
fn strip_leading_keyword(text : String, prefix : String) -> String {
  match text.strip_prefix(prefix) {
    Some(rest) => rest.to_owned().trim().to_owned()
    None => text
  }
}

///|
fn declaration_name(line : String) -> String {
  let mut text = line.trim().to_owned()
  text = strip_leading_keyword(text, "declare pub ")
  text = strip_leading_keyword(text, "pub(all) ")
  text = strip_leading_keyword(text, "pub ")
  text = strip_leading_keyword(text, "fn ")
  text = strip_leading_keyword(text, "struct ")
  text = strip_leading_keyword(text, "enum ")
  text = strip_leading_keyword(text, "type ")
  text = strip_leading_keyword(text, "trait ")
  text = strip_leading_keyword(text, "suberror ")
  let delimiters = ["(", "{", ":", " ", "\t"]
  let mut end = text.length()
  for delimiter in delimiters {
    match text.find(delimiter) {
      Some(index) => if index < end { end = index }
      None => ()
    }
  }
  text[:end].to_owned()
}

///|
fn is_doc_line(line : String) -> Bool {
  let text = line.trim().to_owned()
  text.has_prefix("///") && text != "///|"
}

///|
fn is_blank_or_block_separator(line : String) -> Bool {
  let text = line.trim().to_owned()
  text.is_empty() || text == "///|"
}

///|
fn doc_text(line : String) -> String {
  let text = line.trim().to_owned()
  match text.strip_prefix("///") {
    Some(rest) => rest.to_owned().trim().to_owned()
    None => ""
  }
}

///|
fn has_weak_doc(doc_lines : Array[String], api_name : String) -> Bool {
  if doc_lines.is_empty() {
    false
  } else {
    let joined = doc_lines.join(" ").trim().to_owned()
    let lower = joined.to_lower()
    lower.contains("todo") ||
    lower.contains("fixme") ||
    lower.contains("tbd") ||
    joined.length() < 8 ||
    joined == api_name
  }
}

///|
fn collect_previous_doc(lines : Array[String], index : Int) -> Array[String] {
  let docs : Array[String] = []
  for cursor = index - 1; cursor >= 0; cursor = cursor - 1 {
    let line = lines[cursor]
    if is_doc_line(line) {
      docs.insert(0, doc_text(line))
    } else if is_blank_or_block_separator(line) && docs.is_empty() {
      continue
    } else {
      break
    }
  }
  docs
}

///|
/// Scan a MoonBit source text and return public API items found in it.
pub fn scan_moon_source(file : String, source : String) -> Array[ApiItem] {
  let lines = source.split("\n").map(line => line.to_owned()).collect()
  let items : Array[ApiItem] = []
  for index, line in lines {
    if is_public_declaration(line) {
      let name = declaration_name(line)
      let docs = collect_previous_doc(lines, index)
      let documented = !docs.is_empty()
      items.push({
        name,
        kind: declaration_kind(line),
        file,
        line: index + 1,
        documented,
        weak_doc: documented && has_weak_doc(docs, name),
      })
    }
  }
  items
}
