import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn parse(in: List(String)) {
  in
  |> list.first
  |> result.unwrap("")
  |> string.split(",")
  |> list.map(fn(range) { string.split_once(range, "-") })
  |> result.values
  |> list.map(fn(p) {
    #(int.parse(p.0) |> result.unwrap(0), int.parse(p.1) |> result.unwrap(0))
  })
}

pub fn part1(in: List(String)) -> Int {
  parse(in)
  |> list.flat_map(check)
  |> int.sum
}

fn check(range: #(Int, Int)) -> List(Int) {
  list.range(range.0, range.1)
  |> list.filter(fn(i) {
    let g = int.to_string(i) |> string.to_graphemes
    let #(a, b) = list.split(g, list.length(g) / 2)
    a == b
  })
}

pub fn part2(in: List(String)) -> Int {
  parse(in)
  |> list.flat_map(check2)
  |> int.sum
}

fn check2(range: #(Int, Int)) -> List(Int) {
  list.range(range.0, range.1)
  |> list.filter(fn(i) {
    let g = int.to_string(i) |> string.to_graphemes
    let len = list.length(g)
    list.range(len / 2, 1)
    |> list.filter(fn(size) { len > 1 && len % size == 0 })
    |> list.any(fn(size) { check_size(g, size) })
  })
}

fn check_size(l: List(String), size: Int) {
  let chunks = list.sized_chunk(l, size)
  let first = list.first(chunks) |> result.unwrap([])
  chunks
  |> list.drop(1)
  |> list.all(fn(x) { x == first })
}
