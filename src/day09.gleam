import gleam/int
import gleam/list
import gleam/result
import input
import listx
import point.{type Point, Point}

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
  |> largest
}

fn largest(pairs: List(#(Point, Point))) {
  list.map(pairs, fn(pair) {
    let #(a, b) = pair
    { int.absolute_value(a.x - b.x) + 1 }
    * { int.absolute_value(a.y - b.y) + 1 }
  })
  |> list.max(int.compare)
  |> result.unwrap(0)
}

pub fn part2(in: List(String)) -> Int {
  let points = parse(in)
  let edges =
    points
    |> list.append(list.take(points, 1))
    |> list.window_by_2
    |> list.map(sort)

  let valid_rectangles =
    points
    |> list.combination_pairs
    |> listx.filter_not(fn(pair) {
      let #(p1, p2) = pair
      let #(min_x, max_x) = #(int.min(p1.x, p2.x), int.max(p1.x, p2.x))
      let #(min_y, max_y) = #(int.min(p1.y, p2.y), int.max(p1.y, p2.y))
      list.any(edges, fn(edge) {
        let #(e1, e2) = edge
        case e1.x == e2.x {
          True -> e1.x > min_x && e1.x < max_x && e2.y > min_y && e1.y < max_y
          False -> e1.y > min_y && e1.y < max_y && e2.x > min_x && e1.x < max_x
        }
      })
    })

  valid_rectangles
  |> largest
}

fn sort(pair: #(Point, Point)) {
  let #(a, b) = pair
  case a.x == b.x {
    True ->
      case a.y < b.y {
        True -> #(a, b)
        False -> #(b, a)
      }
    False ->
      case a.x < b.x {
        True -> #(a, b)
        False -> #(b, a)
      }
  }
}
