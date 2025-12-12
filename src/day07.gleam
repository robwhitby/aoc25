import dir
import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import grid.{type Grid}
import input
import point.{type Point, Point}

fn parse(in: List(String)) {
  let g = grid.from_list(input.string_parser(in, ""))

  let s =
    grid.find(g, fn(v) { v == "S" })
    |> result.map(fn(c) { c.point })
    |> result.unwrap(Point(0, 0))

  #(g, s)
}

pub fn part1(in: List(String)) -> Int {
  let #(grid, start) = parse(in)
  loop(grid, [start], 0)
}

fn loop(g: Grid(String), beams: List(Point), splits: Int) {
  let next =
    list.map(beams, point.add(_, dir.s))
    |> list.flat_map(fn(p) {
      case grid.value_at(g, p) {
        Ok("^") -> point.neighbours(p, [dir.e, dir.w])
        Ok(_) -> [p]
        _ -> []
      }
    })
  case next {
    [] -> splits
    _ ->
      loop(
        g,
        list.unique(next),
        splits + list.length(next) - list.length(beams),
      )
  }
}

pub fn part2(in: List(String)) -> Int {
  let #(grid, start) = parse(in)
  loop2(grid, [#(start, 1)])
}

fn loop2(g: Grid(String), beams: List(#(Point, Int))) {
  let next =
    list.map(beams, pair.map_first(_, point.add(_, dir.s)))
    |> list.flat_map(fn(p) {
      case grid.value_at(g, p.0) {
        Ok("^") ->
          point.neighbours(p.0, [dir.e, dir.w])
          |> list.map(fn(n) { #(n, p.1) })
        Ok(_) -> [p]
        _ -> []
      }
    })

  let next_merged =
    list.group(next, fn(p) { p.0 })
    |> dict.to_list
    |> list.map(fn(p) { #(p.0, list.fold(p.1, 0, fn(acc, x) { acc + x.1 })) })

  case next {
    [] -> list.map(beams, fn(p) { p.1 }) |> int.sum
    _ -> loop2(g, next_merged)
  }
}
