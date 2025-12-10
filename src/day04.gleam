import dir
import gleam/list
import grid.{type Cell, type Grid, Cell}
import input
import point

fn parse(in: List(String)) {
  input.string_parser(in, "")
  |> grid.from_list
}

pub fn part1(in: List(String)) -> Int {
  parse(in) |> can_remove |> list.length
}

pub fn part2(in: List(String)) -> Int {
  let g = parse(in)
  count_rolls(g) - count_rolls(remove(g))
}

fn remove(g: Grid(String)) {
  case can_remove(g) {
    [] -> g
    cells ->
      list.fold(cells, g, fn(g2, cell) {
        grid.update(g2, Cell(cell.point, "."))
      })
      |> remove
  }
}

fn can_remove(g: Grid(String)) -> List(Cell(String)) {
  grid.filter(g, fn(c: Cell(String)) {
    c.value == "@"
    && {
      point.neighbours(c.point, dir.all)
      |> list.count(fn(p) { grid.value_at(g, p) == Ok("@") })
      < 4
    }
  })
}

fn count_rolls(g: Grid(String)) {
  grid.filter(g, fn(c: Cell(String)) { c.value == "@" }) |> list.length
}
