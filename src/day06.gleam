import gleam/int
import gleam/list
import gleam/result
import gleam/string
import input
import listx

pub fn part1(in: List(String)) -> Int {
  let ns =
    input.int_parser(in, False)
    |> list.transpose

  let ops =
    list.reverse(in)
    |> list.take(1)
    |> input.string_parser(" ")
    |> list.first
    |> result.unwrap([])
    |> list.map(fn(s) {
      case s {
        "+" -> int.add
        _ -> int.multiply
      }
    })

  list.zip(ns, ops)
  |> list.map(fn(eq: #(List(Int), fn(Int, Int) -> Int)) {
    list.reduce(eq.0, eq.1) |> result.unwrap(0)
  })
  |> int.sum
}

pub fn part2(in: List(String)) -> Int {
  list.map(in, string.to_graphemes)
  |> list.transpose
  |> list.chunk(empty)
  |> listx.filter_not(fn(l) { empty(list.first(l) |> result.unwrap([])) })
  |> list.map(fn(eq) {
    let head = list.first(eq) |> result.unwrap([])
    let len = list.length(head)
    let op = case list.reverse(head) {
      ["+", ..] -> int.add
      _ -> int.multiply
    }
    let ns =
      list.map(eq, fn(l) { list.take(l, len - 1) })
      |> list.map(string.concat)
      |> list.map(string.trim)
      |> list.map(int.parse)
      |> result.values

    list.reduce(ns, op) |> result.unwrap(0)
  })
  |> int.sum
}

fn empty(l: List(String)) {
  list.all(l, fn(s) { s == " " })
}
