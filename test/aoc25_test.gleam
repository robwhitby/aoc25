import aoc.{day}
import day01
import day02
import gleam/io
import gleeunit

pub fn main() {
  aoc.init()
  gleeunit.main()
}

pub fn day_test_() {
  let days = [
    day(1, day01.part1, 3, day01.part2, 6),
    day(2, day02.part1, 1_227_775_554, day02.part2, 4_174_379_265),
  ]
  aoc.build_tests(days)
}

pub fn answers_test() {
  io.println_error(aoc.answers())
}
