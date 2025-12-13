import gleam/int
import gleam/list
import gleam/result
import input
import point.{Point}

fn parse(in: List(String)) {
  input.int_parser(in, False)
  |> list.map(fn(line) {
    case line {
      [x, y] -> Point(x, y)
      _ -> panic
    }
  })
}

pub fn part1(in: List(String)) -> Int {
  parse(in)
  |> list.combination_pairs
  |> list.map(fn(pair) {
    let #(a, b) = pair
    { int.absolute_value(a.x - b.x) + 1 }
    * { int.absolute_value(a.y - b.y) + 1 }
  })
  |> list.max(int.compare)
  |> result.unwrap(0)
}

pub fn part2(in: List(String)) -> Int {
  0
}
