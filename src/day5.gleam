import simplifile
import gleam/result
import gleam/io
import gleam/string
import gleam/list
import gleam/int

pub type Mapping {
  Entry(dest: Int, source: Int, range: Int)
}

pub type Map {
  Map(name: String, l: List(Mapping))
}

pub fn execute(){
  let assert input = simplifile.read("inputs/day5.txt") |> result.unwrap("Something went wrong")


  let split = input
    |> string.split("\n\n")

  let seeds = list.first(split)
    |> result.unwrap("")
    |> string.split(" ")
    |> list.drop(1)
    |> list.map(fn(x) { int.parse(x) |> result.unwrap(0) })

  let maps = split
    |> list.drop(1)
    |> list.map(to_map(_))

  io.println("Part 1 ============================================")

  seeds
  |> list.map(fn(x) { process_one_seed(x, maps) })
  |> list.reduce(fn(a, b) {
    case a > b {
      True -> b
      False -> a
    }
  })
  |> result.unwrap(-1)
  |> io.debug()

}

fn process_one_seed(seed: Int, maps: List(Map)) {
  maps
  |> list.fold(seed, fn(acc, m){
      process_one_map(acc, m.l)
    })
}

fn process_one_map(seed: Int, l: List(Mapping)) {
  case l {
    [] -> seed
    [first, ..] -> {
      case process_one_entry(seed, first) {
        x if x != seed -> x
        y -> process_one_map(y, list.drop(l, 1))
      }
    }
  }

}

fn process_one_entry(acc: Int, e: Mapping) {
      let max = e.source + e.range
      let out = case acc {
        x if x >= e.source && x < max -> x - e.source + e.dest
        y -> y
      }
      // io.debug(out)
      out
}

fn to_map(s: String) {
  let split = s |> string.split("\n")

  let l = split
    |> list.drop(1)
    |> list.map(
      fn(x){
        let sp = string.split(x, " ")
        let source = sp |> list.first() |> result.unwrap("") |> int.parse() |> result.unwrap(0)
        let dest = sp |> list.drop(1) |> list.first() |> result.unwrap("") |> int.parse() |> result.unwrap(0)
        let range = sp |> list.drop(2) |> list.first() |> result.unwrap("") |> int.parse() |> result.unwrap(0)
        Entry(source, dest, range)
      }
    )

  Map(list.first(split) |> result.unwrap(""), l)

}
