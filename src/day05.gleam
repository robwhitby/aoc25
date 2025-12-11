import gleam/int
import gleam/list

import gleam/result
import gleam/string

fn parse(in: List(String)) {
  let ranges =
    list.take_while(in, fn(s) { s != "" })
    |> list.map(fn(line) { string.split_once(line, "-") })
    |> result.values
    |> list.map(fn(p) {
      #(int.parse(p.0) |> result.unwrap(0), int.parse(p.1) |> result.unwrap(0))
    })

  let available =
    list.drop(in, list.length(ranges))
    |> list.map(int.parse)
    |> result.values

  #(ranges, available)
}

pub fn part1(in: List(String)) -> Int {
  let #(ranges, available) = parse(in)
  list.count(available, fn(i: Int) {
    list.any(ranges, fn(r) { r.0 <= i && r.1 >= i })
  })
}

pub fn part2(in: List(String)) -> Int {
  let #(ranges, _) = parse(in)
  let sorted = list.sort(ranges, fn(a, b) { int.compare(a.0, b.0) })
  merge([], sorted)
  |> list.fold(0, fn(acc, r) { acc + r.1 - r.0 + 1 })
}

fn merge(done: List(#(Int, Int)), remaining: List(#(Int, Int))) {
  case remaining {
    [] -> done
    [current, ..rest] -> {
      case done {
        [] -> merge([current], rest)
        [last, ..rest_merged] -> {
          case current.0 <= last.1 + 1 {
            True -> {
              let new_range = #(last.0, int.max(last.1, current.1))
              merge([new_range, ..rest_merged], rest)
            }
            False -> {
              merge([current, ..done], rest)
            }
          }
        }
      }
    }
  }
}
