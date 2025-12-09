import aoc.{day}
import day01
import gleam/io
import gleeunit

pub fn main() {
  aoc.init()
  gleeunit.main()
}

pub fn day_test_() {
  let days = [
    day(1, day01.part1, 3, day01.part2, 6),
  ]
  aoc.build_tests(days)
}

pub fn answers_test() {
  io.println_error(aoc.answers())
}
