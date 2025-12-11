import aoc.{day}
import day01
import day02
import day03
import day04
import day05
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
    day(3, day03.part1, 357, day03.part2, 3_121_910_778_619),
    day(4, day04.part1, 13, day04.part2, 43),
    day(5, day05.part1, 3, day05.part2, 14),
  ]
  aoc.build_tests(days)
}

pub fn answers_test() {
  io.println_error(aoc.answers())
}
