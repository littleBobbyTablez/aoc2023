import simplifile
import gleam/io
import gleam/result
import gleam/string
import gleam/list
import gleam/int

pub fn execute() {

  let assert input = simplifile.read("inputs/day9.txt") |> result.unwrap("Something went wrong")

  let seqs = input
  |> string.trim()
  |> string.split("\n")
  |> list.map( fn(s) { string.split(s, " ") |> list.map( fn(i){ int.parse(i) |> result.unwrap(0) })} )


  io.println("Part 1 ==============================================")

  seqs
  |> list.map(fn(s) { calculate_next(s, [])})
  |> list.map(fn(l) { list.reverse(l)
                      |> list.map(fn(l) { list.last(l) |> result.unwrap(0) })
                      |> list.reduce( fn(x, y) {x + y} )
                      |> result.unwrap(0)})
  |> list.reduce(fn(a, b) { a + b })
  |> result.unwrap(0)
  |> io.debug()


  io.println("Part 2 ==============================================")


  seqs
  |> list.map(fn(s) { calculate_next(s, [])})
  |> list.map(fn(l) { list.reverse(l)
                      |> list.map(fn(l) { list.first(l) |> result.unwrap(0) })
                      |> list.reduce( fn(x, y) {y - x} )
                      |> result.unwrap(0)
                      })
  |> list.reduce(fn(a, b) { a + b })
  |> result.unwrap(0)
  |> io.debug()
}

pub fn calculate_next(current: List(Int), results: List(List(Int))) {
  case current |> list.all( fn(i){ i == 0 }) {
    True -> list.append(results, [current])
    False -> calculate_next(calculate_distances(current, []), list.append(results, [current])
    )
  }

}

pub fn calculate_distances(in: List(Int), out: List(Int)) {
  case in {
     [_] -> out
     [first, second, ..] -> calculate_distances(list.drop(in, 1), list.append(out, [second - first]))
     _ -> panic
  }
}


