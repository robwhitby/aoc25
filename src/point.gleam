import gleam/int
import gleam/list

pub type Point {
  Point(x: Int, y: Int)
}

pub fn add(from: Point, step: Point) -> Point {
  Point(from.x + step.x, from.y + step.y)
}

pub fn subtract(from: Point, step: Point) -> Point {
  Point(from.x - step.x, from.y - step.y)
}

pub fn neighbours(from: Point, steps: List(Point)) -> List(Point) {
  steps |> list.map(add(from, _))
}

pub fn flip(point: Point) -> Point {
  Point(point.y, point.x)
}

pub fn to_string(point: Point) {
  int.to_string(point.x) <> "," <> int.to_string(point.y)
}

pub fn distance(a: Point, b: Point) {
  int.absolute_value(a.x - b.x) + int.absolute_value(a.y - b.y)
}
