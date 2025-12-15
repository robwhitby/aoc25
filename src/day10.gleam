import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regexp.{Match}
import gleam/result
import gleam/string

type Machine {
  Machine(lights: List(Bool), buttons: List(List(Int)))
}

fn parse(in: List(String)) {
  let assert Ok(lights_re) = regexp.from_string("\\[(.+?)\\]")
  let assert Ok(buttons_re) = regexp.from_string("\\((.+?)\\)")

  list.map(in, fn(line) {
    let lights = case regexp.scan(lights_re, line) {
      [Match(_, [Some(a)])] ->
        string.to_graphemes(a) |> list.map(fn(c) { c == "#" })
      _ -> []
    }

    let state = list.repeat(False, list.length(lights))

    let buttons =
      regexp.scan(buttons_re, line)
      |> list.map(fn(match) {
        case match {
          Match(_, [Some(a)]) ->
            string.split(a, ",")
            |> list.map(int.parse)
            |> result.values
          _ -> []
        }
      })

    Machine(lights, buttons)
  })
}

pub fn part1(in: List(String)) -> Int {
  parse(in)
  |> list.map(fn(machine) {
    list.range(1, list.length(machine.buttons))
    |> list.find(press_n(machine, _))
    |> result.unwrap(0)
  })
  |> int.sum
}

fn press_n(machine: Machine, n: Int) {
  let init = list.repeat(False, list.length(machine.lights))
  list.combinations(machine.buttons, n)
  |> list.any(fn(btns) { list.fold(btns, init, press) == machine.lights })
}

fn press(state: List(Bool), button: List(Int)) {
  list.index_map(state, fn(light, i) {
    case list.contains(button, i) {
      True -> !light
      False -> light
    }
  })
}

pub fn part2(in: List(String)) -> Int {
  0
}
