import gleam/pair
import gleam/dict
import gleam/float
import gleam/int
import gleam/list.{Continue, Stop}
import gleam/result
import input

type Point {
  Point(x: Int, y: Int, z: Int)
}

fn distance(a: Point, b: Point) {
  [
    a.x - b.x,
    a.y - b.y,
    a.z - b.z,
  ]
  |> list.map(int.power(_, 2.0))
  |> result.values
  |> list.map(float.round)
  |> int.sum
  |> int.square_root
  |> result.unwrap(0.0)
}

fn parse(in: List(String)) {
  input.int_parser(in, False)
  |> list.map(fn(line) {
    case line {
      [x, y, z] -> Ok(Point(x, y, z))
      _ -> Error(Nil)
    }
  })
  |> result.values
}

pub fn part1(in: List(String)) -> Int {
  let boxes = parse(in)

  closest_pairs(boxes)
  |> list.take(1000)
  |> list.index_fold(dict.new(), fn(acc, pair, i) {
    let c0 = dict.get(acc, pair.0)
    let c1 = dict.get(acc, pair.1)
    case c0, c1 {
      Error(Nil), Error(Nil) ->
        dict.insert(acc, pair.0, i) |> dict.insert(pair.1, i)
      Ok(j), Ok(k) ->
        dict.map_values(acc, fn(_, v) {
          case v == k {
            True -> j
            False -> v
          }
        })
      Ok(j), _ -> dict.insert(acc, pair.1, j)
      _, Ok(k) -> dict.insert(acc, pair.0, k)
    }
  })
  |> dict.to_list
  |> list.group(fn(p) { p.1 })
  |> dict.to_list
  |> list.map(fn(p) { list.length(p.1) })
  |> list.sort(int.compare)
  |> list.reverse
  |> list.take(3)
  |> list.reduce(int.multiply)
  |> result.unwrap(0)
}

fn closest_pairs(ps: List(Point)) {
  let pairs = list.combination_pairs(ps)
  list.map(pairs, fn(p) { #(p, distance(p.0, p.1)) })
  |> list.sort(fn(a, b) { float.compare(a.1, b.1) })
  |> list.map(fn(t) { t.0 })
}

pub fn part2(in: List(String)) -> Int {
  let boxes = parse(in)

  closest_pairs(boxes)
  |> list.fold_until(#(dict.new(), 0), fn(acc, pair) {
    let c0 = dict.get(acc.0, pair.0)
    let c1 = dict.get(acc.0, pair.1)
    let acc1 = case c0, c1 {
      Error(Nil), Error(Nil) ->
        dict.insert(acc.0, pair.0, acc.1) |> dict.insert(pair.1, acc.1)
      Ok(j), Ok(k) ->
        dict.map_values(acc.0, fn(_, v) {
          case v == k {
            True -> j
            False -> v
          }
        })
      Ok(j), _ -> dict.insert(acc.0, pair.1, j)
      _, Ok(k) -> dict.insert(acc.0, pair.0, k)
    }

    case
      list.length(dict.keys(acc1)) == list.length(boxes)
      && dict.values(acc1) |> list.unique |> list.length == 1
    {
      True -> {
        Stop(#(acc1, { pair.0 }.x * { pair.1 }.x))
      }
      False -> Continue(#(acc1, acc.1 + 1))
    }
  })
  |> pair.second
}
