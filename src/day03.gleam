import gleam/float
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

fn parse(in: List(String)) {
  list.map(in, fn(line) {
    string.to_graphemes(line)
    |> list.map(int.parse)
    |> result.values
  })
}

pub fn part1(in: List(String)) -> Int {
  parse(in)
  |> list.map(fn(l) { joltage(l, 2) })
  |> int.sum
}

pub fn part2(in: List(String)) -> Int {
  parse(in)
  |> list.map(fn(l) { joltage(l, 12) })
  |> int.sum
}

fn joltage(bank: List(Int), n: Int) -> Int {
  list.range(n - 1, 0)
  |> list.fold(#([], bank), fn(acc, i) {
    let next = next_digit(acc.1, i)
    #([next.0, ..acc.0], next.1)
  })
  |> pair.first
  |> list.index_fold(0, fn(acc, i, idx) {
    let n = int.power(10, int.to_float(idx)) |> result.unwrap(0.0)
    acc + { i * float.round(n) }
  })
}

fn next_digit(bank: List(Int), i: Int) {
  let a =
    list.reverse(bank)
    |> list.drop(i)
    |> list.max(int.compare)
    |> result.unwrap(0)
  let rest = list.drop_while(bank, fn(i) { i != a }) |> list.drop(1)
  #(a, rest)
}
