import gleam/int.{to_string}
import gleam/list
import gleam/string.{concat}
import gleeunit/should
import input
import simplifile

const output_file = "./answers"

pub fn build_tests(days: List(List(TestSpec))) {
  Inparallel(list.flatten(days))
}

pub fn day(
  number: Int,
  part1: PartFn(a),
  example1: a,
  part2: PartFn(b),
  example2: b,
) {
  [
    build_part(number, 1, part1, example1),
    build_part(number, 2, part2, example2),
  ]
}

fn build_part(day_number: Int, part: Int, f: PartFn(a), example: a) {
  let day_num = string.pad_start(to_string(day_number), 2, "0")
  let title = concat(["Day ", day_num, ".", to_string(part)])
  let func = fn() {
    let data_ex = input.read(day_num <> "_ex")
    f(data_ex) |> should.equal(example)
    let data = input.read(day_num)
    let result = f(data)
    let _ =
      simplifile.append(
        output_file,
        concat([title, ": ", string.inspect(result), "\n"]),
      )
    True
  }
  Timeout(60, #(title, func))
}

pub fn init() -> Nil {
  let _ = simplifile.write(output_file, "")
  Nil
}

pub fn answers() {
  let assert Ok(content) = simplifile.read(output_file)
  content
  |> string.split("\n")
  |> list.sort(string.compare)
  |> string.join("\n")
}

type PartFn(a) =
  fn(List(String)) -> a

pub opaque type TestSpec {
  Timeout(Int, #(String, fn() -> Bool))
}

pub opaque type TestGroup {
  Inparallel(List(TestSpec))
}
