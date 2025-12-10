import point.{type Point, Point}

pub const n = Point(0, -1)

pub const e = Point(1, 0)

pub const s = Point(0, 1)

pub const w = Point(-1, 0)

pub const ne = Point(1, -1)

pub const nw = Point(-1, -1)

pub const se = Point(1, 1)

pub const sw = Point(-1, 1)

pub const all = [n, e, s, w, ne, nw, se, sw]

pub const nesw = [n, e, s, w]

pub const diagonals = [ne, nw, se, sw]

pub fn rotate90(d: Point) {
  Point(-d.y, d.x)
}

pub fn rotate270(d: Point) {
  Point(d.y, -d.x)
}
