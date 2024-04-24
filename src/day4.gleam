import simplifile
import gleam/result
import gleam/string
import gleam/io
import gleam/list
import gleam/int
import gleam/dict
import gleam/option

pub fn execute() {
  let assert input = simplifile.read("inputs/day4.txt") |> result.unwrap("Something went wrong")

  let parsed = input
  |> string.trim()
  |> string.split("\n")
  |> list.map(fn(l) {
    let s = string.split(l, ": ")
    let c = list.last(s)
    |> result.unwrap("")
    |> string.split(" | ")
    |> list.map(fn(e) { string.split(e, " ") |> list.filter(fn(e){ e != "" }) })
    #(list.first(s) |> result.unwrap(""), list.first(c) |> result.unwrap([]), list.last(c) |> result.unwrap([]))
    })

  io.println("Part 1 ==============================================")

  parsed
  |> list.map(fn(e){
      e.2 |> list.filter(fn(n) { list.contains(e.1, n) })
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

  io.println("Part 2 ==============================================")

  let d = parsed |> list.map( fn(x) { #(x.0, 1) }) |> dict.from_list

  parsed
  |> calculate_recursively(d)
  |> result.unwrap(0)
  |> int.to_string()
  |> io.println()

}

fn calculate_recursively(l: List(#(String, List(String), List(String))), d: dict.Dict(String, Int)) {
  case l {
    [] -> dict.values(d) |> list.reduce(fn(acc, x) { acc + x })
    _ -> {
    let current = list.pop(l, fn(_){True}) |> result.unwrap(#(#("",[],[]), []))
    let next = current.0
    let rest = current.1

    let n = next.2 |> list.filter(fn(e) { list.contains(next.1, e)}) |> list.length()

    let to_add = rest |> list.take(n)

    let current_count = dict.get(d, next.0) |> result.unwrap(1)

    let new_d = to_add |> list.fold(d, fn(di, a){
      let increment = fn(x) { increment_and_multiply(x, current_count) }
      dict.update(di, a.0, increment)
    })

    calculate_recursively(rest, new_d)
    }
  }
}

fn increment_and_multiply(x: option.Option(Int), n: Int) {
  case x {
    option.Some(i) -> i + n
    _ -> 1 // should not happen, the dict is initialized
  }
}
