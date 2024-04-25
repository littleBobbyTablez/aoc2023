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

pub type Relation {
  Nothing
  Intersect
  Contained
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
  |> int.to_string()
  |> io.println()

  io.println("Part 2 ============================================")

  let seed_ranges = seeds
    |> parse_seed_ranges([])

  seed_ranges
  |> list.map(fn(s) {
    calculate_seed_ranges([s], maps)
  })
  |> list.flatten()
  |> list.map(fn(x) { x.source })
  |> list.reduce(fn(a, b) {
    case a > b {
      True -> b
      False -> a
    }
  })
  |> result.unwrap(-1)
  |> int.to_string()
  |> io.println()


}

pub fn calculate_seed_ranges(l: List(Mapping), maps: List(Map)) {
  case maps {
    [] -> l
    [map, ..] -> {
      let t = l
      |> list.map(fn(s) {
        transform(s, [], map.l)
      })
      |> list.flatten()

      calculate_seed_ranges(t, maps |> list.drop(1))
    }
  }
}

pub fn transform(in: Mapping, out: List(Mapping), maps: List(Mapping)) {
  case maps {
    [] -> out
    [map, ..] -> {
        case calculate_relation(in, map) {

          Nothing -> {
            let remaining = maps |> list.drop(1)
            case remaining {
              [] -> transform(in, list.append(out, [in]), remaining)
              _ -> transform(in, out, remaining)
            }
          }

          Contained -> {
            let offset = in.source - map.source
            let t = Entry(0, map.dest + offset, in.range)
            transform(in, list.append(out, [t]), [])
          }

          Intersect -> {
            case in.source < map.source {
              True -> {
                let new_range = map.source - in.source
                let rest = Entry(0, in.source, new_range)
                let t = Entry(0, map.dest, in.range - new_range)

                let remaining = maps |> list.drop(1)
                case remaining {
                  [] -> transform(rest, list.append(out, [rest, t]), remaining)
                  _ -> transform(rest, list.append(out, [t]), remaining)
                }

              }
              False -> {
                let max_map = map.source + map.range
                let max_in = in.source + in.range
                let new_range = max_in - max_map
                let rest = Entry(0, max_map, new_range)
                let offset = in.source - map.source
                let t = Entry(0, map.dest + offset, max_map - in.source)

                let remaining = maps |> list.drop(1)
                case remaining {
                  [] -> transform(rest, list.append(out, [rest, t]), remaining)
                  _ -> transform(rest, list.append(out, [t]), remaining)
                }
              }
            }
          }
        }
      }
  }
}

pub fn calculate_relation(seeds: Mapping, map: Mapping) {
  let max_map = map.source + map.range
  let max_seed = seeds.source + seeds.range

  case seeds.source >= map.source {
    True if max_seed < max_map -> Contained
    True if seeds.source > max_map -> Nothing
    True -> Intersect
    False if max_seed < map.source -> Nothing
    False -> Intersect
  }
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

fn parse_seed_ranges(l: List(Int), out: List(Mapping)) {
  case l {
    [] -> out
    [first, second, ..] -> parse_seed_ranges(l |> list.drop(2), list.append(out, [Entry(0, first, second)]))
    _ -> panic()
  }
}
