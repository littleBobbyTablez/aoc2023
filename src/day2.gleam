import simplifile
import gleam/io
import gleam/string
import gleam/list
import gleam/dict
import gleam/int
import gleam/result

pub fn execute() {
  let assert Ok(content) = simplifile.read("inputs/day2.txt")

  let games = content
  |> string.split("\n")


  let minimum_set = games
  |> list.map(fn(g){ string.split(g, ": ") |> list.drop(1) })
  |> list.flatten()
  |> list.map(fn(g){ string.split(g, "; ") |> list.map(fn(x){ string.split(x, ", ")}) |> list.flatten()})
  |> list.map(fn(e){ find_max_for_each_color(e) })

  io.println("Part 1 ================================================")

  minimum_set
  |> list.zip(list.range(1, list.length(games)))
  |> list.filter(fn(x) { {dict.get(x.0, "red") |> result.unwrap(0)} <= 12 && {dict.get(x.0, "green") |> result.unwrap(0)} <= 13 && {dict.get(x.0, "blue") |> result.unwrap(0)} <= 14})
  |> list.fold(0, fn(acc, x){ acc + x.1})
  |> int.to_string()
  |> io.println()


  io.println("Part 2 ================================================")

  minimum_set
  |> list.map(fn(d){ dict.values(d) |> list.reduce(fn(acc, n){ acc * n }) |> result.unwrap(0) })
  |> list.reduce(fn(acc, n){ acc + n })
  |> result.unwrap(0)
  |> io.debug()
}


fn find_max_for_each_color(l: List(String)) {
  l
  |> list.fold(dict.new(), fn(d, s){
    let sp = string.split(s, " ")
    let n = list.first(sp) |> result.unwrap("0") |> int.parse() |> result.unwrap(0)
    let color = list.last(sp) |> result.unwrap("black")

    let old = dict.get(d, color) |> result.unwrap(0)
    case old >= n {
      True -> d
      False -> dict.insert(d, color, n)
    }
  })
}
