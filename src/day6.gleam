import simplifile
import gleam/io
import gleam/list
import gleam/string
import gleam/result
import gleam/int

pub fn execute() {

  let assert input = simplifile.read("inputs/day6.txt") |> result.unwrap("Something went wrong")

  let lines = input |> string.trim() |> string.split("\n")

  let list = lines
  |> list.map(fn(l) {
      l |> string.split(" ") |> list.filter(fn(x) { x != "" })
    })

  let races = case list {
    [time, distance] -> list.zip(list.drop(time, 1), list.drop(distance, 1))
    _ -> panic
  }

  io.println("Part 1 ================================================")

  races
  |> list.map(fn(r) { #(r.0 |> int.parse() |> result.unwrap(0), r.1 |> int.parse |> result.unwrap(0)) })
  |> list.map(fn(r) { calculate_race(r.0, r.1) })
  |> list.reduce(fn(a, b) { a * b })
  |> result.unwrap(0)
  |> int.to_string()
  |> io.println()

  io.println("Part 2 ================================================")

  calculate_race(40929790, 215106415051100)
  |> int.to_string()
  |> io.println()
}

fn calculate_race(t: Int, d: Int) {
  let possibilities = list.range(0, t) |> list.zip(list.range(t, 0))

  possibilities
  |> list.map(fn(x) {
      x.0 * x.1
    })
  |> list.filter(fn(dist) { dist > d })
  |> list.length
}
