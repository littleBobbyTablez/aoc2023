import simplifile
import gleam/result
import gleam/string
import gleam/io
import gleam/list
import gleam/int

pub fn execute() {
  let assert input = simplifile.read("inputs/day4.txt") |> result.unwrap("Something went wrong")

  let lines = input
  |> string.trim()
  |> string.split("\n")
  |> list.map(fn(l) {
    let s = string.split(l, ": ")
    let c = list.last(s)
    |> result.unwrap("")
    |> string.split(" | ")
    |> list.map(fn(e) { string.split(e, " ") |> list.filter(fn(e){ e != "" }) })
    #(list.first(c) |> result.unwrap([]), list.last(c) |> result.unwrap([]))
    })
  |> list.map(fn(e){
      e.1 |> list.filter(fn(n) { list.contains(e.0, n) })
    })
  |> list.map(fn(l){
    case l {
      [] -> 0
      _ -> list.fold( list.rest(l) |> result.unwrap([]), 1, fn(acc, _ ){ acc * 2 } )
      }
    })
  |> list.reduce(fn(acc, i){ acc + i })
  |> result.unwrap(0)
  |> int.to_string()
  |> io.println()
  // |> io.debug()
}
