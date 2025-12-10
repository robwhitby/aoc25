import gleam/dict.{type Dict}
import gleam/function
import gleam/int
import gleam/list
import parallel_map.{MatchSchedulersOnline}

pub fn filter_not(in l: List(a), discarding predicate: fn(a) -> Bool) -> List(a) {
  list.filter(l, fn(a) { !predicate(a) })
}

pub fn pmap(input: List(a), mapping_func: fn(a) -> b) -> List(Result(b, Nil)) {
  parallel_map.list_pmap(input, mapping_func, MatchSchedulersOnline, 5000)
}

pub fn count_contiguous(ints: List(Int)) -> Int {
  case ints {
    [] -> 0
    _ ->
      1
      + {
        ints
        |> list.sort(int.compare)
        |> list.window_by_2
        |> list.map(fn(pair) { pair.1 - pair.0 != 1 })
        |> list.count(fn(b) { b })
      }
  }
}

pub fn count_uniq(in l: List(a)) -> Dict(a, Int) {
  list.group(l, function.identity)
  |> dict.map_values(fn(_, v) { list.length(v) })
}
