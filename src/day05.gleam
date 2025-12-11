import gleam/int
import gleam/list
import gleam/order
import gleam/pair
import gleam/result
import gleam/string

fn parse(in: List(String)) {
  let fresh =
    list.take_while(in, fn(s) { s != "" })
    |> list.map(fn(line) { string.split_once(line, "-") })
    |> result.values
    |> list.map(fn(p) {
      #(int.parse(p.0) |> result.unwrap(0), int.parse(p.1) |> result.unwrap(0))
    })

  let available =
    list.drop(in, list.length(fresh))
    |> list.map(int.parse)
    |> result.values

  #(fresh, available)
}

pub fn part1(in: List(String)) -> Int {
  let #(fresh, available) = parse(in)
  list.count(available, fn(i: Int) {
    list.any(fresh, fn(r) { r.0 <= i && r.1 >= i })
  })
}

pub fn part2(in: List(String)) -> Int {
  let #(fresh, _) = parse(in)
  0
}
