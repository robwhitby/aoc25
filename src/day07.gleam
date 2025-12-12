import dir
import gleam/list
import gleam/result
import grid.{type Grid}
import input
import point.{type Point, Point}

fn parse(in: List(String)) {
  grid.from_list(input.string_parser(in, ""))
}

fn eq(a: t) -> fn(t) -> Bool {
  fn(b: t) { a == b }
}

pub fn part1(in: List(String)) -> Int {
  let g = parse(in)
  let s =
    grid.find(g, eq("S"))
    |> result.map(fn(c) { c.point })
    |> result.unwrap(Point(0, 0))

  loop(g, [s], 0)
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
  0
}
