import aoc.{day}
import day01
import day02
import day03
import day04
import day05
import day06
import day07
import day08
import day09
import day10
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
    day(6, day06.part1, 4_277_556, day06.part2, 3_263_827),
    day(7, day07.part1, 21, day07.part2, 40),
    day(8, day08.part1, 20, day08.part2, 25_272),
    day(9, day09.part1, 50, day09.part2, 24),
    day(10, day10.part1, 7, day10.part2, 0),
  ]
  aoc.build_tests(days)
}

pub fn answers_test() {
  io.println_error(aoc.answers())
}
