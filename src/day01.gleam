import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

type Rotation =
  fn(Int) -> Int

fn parse(in: List(String)) {
  list.map(in, fn(line) {
    let n = line |> string.drop_start(1) |> int.parse |> result.unwrap(0)
    case line |> string.first {
      Ok("R") -> int.add(_, n)
      _ -> int.subtract(_, n)
    }
  })
}

pub fn part1(in: List(String)) -> Int {
  parse(in)
  |> list.fold(#(50, 0), fn(acc: #(Int, Int), r: Rotation) {
    let next = turn(acc.0, r)
    let zeros = case next {
      0 -> acc.1 + 1
      _ -> acc.1
    }
    #(next, zeros)
  })
  |> pair.second
}

fn turn(from: Int, r: Rotation) -> Int {
  case r(from) % 100 {
    n if n < 0 -> n + 100
    n if n > 99 -> n - 100
    n -> n
  }
}

pub fn part2(in: List(String)) -> Int {
  parse(in)
  |> list.fold(#(50, 0), fn(acc: #(Int, Int), r: Rotation) {
    let next = turn2(acc.0, r)
    #(next.0, acc.1 + next.1)
  })
  |> pair.second
}

fn turn2(from: Int, r: Rotation) -> #(Int, Int) {
  let raw = r(from)
  let next = turn(from, r)

  let hundreds = case int.absolute_value(raw) {
    x if x % 100 == 0 -> int.max(0, { x / 100 } - 1)
    x -> x / 100
  }

  let loops = case next {
    0 -> hundreds + 1
    _ -> hundreds
  }

  case raw {
    r if r < 0 && from > 0 -> {
      #(next, loops + 1)
    }
    _ -> #(next, loops)
  }
}
