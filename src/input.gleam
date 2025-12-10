import gleam/int
import gleam/list
import gleam/regexp
import gleam/string.{concat}
import listx
import simplifile

pub fn read(name: String) -> List(String) {
  let path = concat(["./inputs/day", name <> ".txt"])
  case simplifile.read(path) {
    Ok(content) -> {
      string.split(content, "\n")
      |> listx.filter_not(string.is_empty)
    }
    Error(_) -> panic as string.concat(["error reading ", path])
  }
}

pub fn string_parser(lines: List(String), delim: String) -> List(List(String)) {
  list.map(lines, split(_, delim))
}

pub fn int_parser(lines: List(String), single_digits: Bool) -> List(List(Int)) {
  let assert Ok(re) = regexp.from_string("[^\\-\\d+]")
  list.map(lines, fn(line) {
    case single_digits {
      True -> split(line, "")
      False -> regexp.replace(re, line, " ") |> split(" ")
    }
    |> list.filter_map(int.parse)
  })
}

fn split(in: String, delim: String) -> List(String) {
  case delim {
    "" -> string.to_graphemes(in)
    _ -> string.split(in, delim)
  }
  |> listx.filter_not(string.is_empty)
}
