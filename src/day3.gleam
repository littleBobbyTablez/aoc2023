import gleam/io
import gleam/result
import simplifile
import gleam/string
import gleam/list
import gleam/dict
import gleam/int

pub type Sign {
  Number(x: Int, y: Int, length: Int, s: String)
  // Symbol(x: Int, y: Int, s: String)
}

pub fn execute() {
  let assert input = simplifile.read("inputs/day3.txt") |> result.unwrap("Something went wrong")

  let lines = input
  |> string.trim()
  |> string.split("\n")

  let numbers = lines
  |> list.zip(list.range(0, list.length(lines) - 1))
  |> list.map(fn(l){ find_numbers(l.0 <> ".", l.1) })
  |> list.flatten()
  |> list.fold(dict.new(), fn(acc, n) {
    let key = int.to_string(n.x) <> " "  <> int.to_string(n.y)
    dict.insert(acc, key, n.s)
  })

  let symbols = lines
  |> list.zip(list.range(0, list.length(lines) - 1))
  |> list.map(fn(l){ find_symbols(l.0 <> ".", l.1) }) // we have to pad the line in case a numer is at the end of the line
  |> list.flatten()
  |> list.fold(dict.new(), fn(acc, n) {
    let key = int.to_string(n.x) <> " "  <> int.to_string(n.y)
    dict.insert(acc, key, n.s)
  })

  let with_neighbour = numbers
  |> dict.filter(fn(k,v){ list.length(has_adjacent_symbol(k, string.length(v), v, symbols)) >= 1 })

  io.println("Part 1 ================================================")

  with_neighbour
  |> dict.values()
  |> list.fold(0, fn(acc, e){ {int.parse(e) |> result.unwrap(0)} + acc })
  |> int.to_string()
  |> io.println()

  io.println("Part 2 ================================================")

  numbers
  |> dict.filter(fn(k,v){
        let a = has_adjacent_symbol(k, string.length(v), v, symbols)
      let symbol = list.first(a) |> result.unwrap(#("", "", []))
      list.length(a) >= 1 && symbol.1 == "*"
    })
  |> dict.to_list()
  |> list.map(fn(t){
      let a = has_adjacent_symbol(t.0, string.length(t.1), t.1, symbols)
      let symbol = list.first(a) |> result.unwrap(#("", "", []))
      symbol
    })
  |> list.fold(dict.new(), fn(acc, t){
      let entry = dict.get(acc, t.0)
      case entry {
        Ok(#(some, count)) -> dict.insert(acc, t.0, #(list.append(t.2, some), count + 1))
        Error(_) -> dict.insert(acc, t.0, #(t.2, 1))
      }
    })
  |> dict.filter(fn(_,v){ v.1 == 2 })
  |> dict.to_list()
  |> list.map(fn(t){
    let x = t.1
    x.0 |> list.map(fn(e){ int.parse(e) |> result.unwrap(1) }) |> list.reduce(fn(acc, y) { acc * y })
  })
  |> list.map(fn(e){ result.unwrap(e, 1) })
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> int.to_string()
  |> io.println()

}

fn has_adjacent_symbol(s: String, len: Int, v: String ,symbols: dict.Dict(String, String)) {
  let coordinates = string.split(s, " ")
  let start_x = list.first(coordinates) |> result.unwrap("0") |> int.parse() |> result.unwrap(0)
  let start_y = list.last(coordinates) |> result.unwrap("0") |> int.parse() |> result.unwrap(0)

  let  lines = list.range(start_y - 1, start_y + 1)

  list.range(start_x - 1, start_x + len )
  |> list.fold([], fn(acc, x) {
      let found = lines |> list.map(fn(y){
          let key = int.to_string(x) <> " " <> int.to_string(y)
          #(key, dict.get(symbols, key))
        })
      |> list.filter(fn(e) { result.is_ok(e.1) })
      list.append(acc, found)
    })
  |> list.map(fn(s) { #(s.0, result.unwrap(s.1, "."), [v]) })
}

fn find_numbers(l: String, row: Int) {
  let rslt = l
  |> string.to_graphemes()
  |> list.fold(#([], False, Number(0, row, 0, "")), fn(acc, s){
    let current_number = acc.2
    case s {
      "" if acc.1 -> #(list.append(acc.0,  [acc.2]), False, current_number)
      "" ->  acc
      "1" -> #(acc.0, True, Number(current_number.x, row, current_number.length + 1, current_number.s <> s))
      "2" -> #(acc.0, True, Number(current_number.x, row, current_number.length + 1, current_number.s <> s))
      "3" -> #(acc.0, True, Number(current_number.x, row, current_number.length + 1, current_number.s <> s))
      "4" -> #(acc.0, True, Number(current_number.x, row, current_number.length + 1, current_number.s <> s))
      "5" -> #(acc.0, True, Number(current_number.x, row, current_number.length + 1, current_number.s <> s))
      "6" -> #(acc.0, True, Number(current_number.x, row, current_number.length + 1, current_number.s <> s))
      "7" -> #(acc.0, True, Number(current_number.x, row, current_number.length + 1, current_number.s <> s))
      "8" -> #(acc.0, True, Number(current_number.x, row, current_number.length + 1, current_number.s <> s))
      "9" -> #(acc.0, True, Number(current_number.x, row, current_number.length + 1, current_number.s <> s))
      "0" -> #(acc.0, True, Number(current_number.x, row, current_number.length + 1, current_number.s <> s))
      _ if acc.1 -> #(list.append(acc.0,  [acc.2]), False, Number(current_number.x + current_number.length + 1, row, 0, ""))
      _ -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
    }
  })
  rslt.0
}

fn find_symbols(l: String, row: Int) {
  let rslt = l
  |> string.to_graphemes()
  |> list.fold(#([], False, Number(0, row, 0, "")), fn(acc, s){
    let current_number = acc.2
    case s {
      "" if acc.1 -> #(list.append(acc.0,  [acc.2]), False, current_number)
      "" ->  acc
      "1" -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
      "2" -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
      "3" -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
      "4" -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
      "5" -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
      "6" -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
      "7" -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
      "8" -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
      "9" -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
      "0" -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
      "." -> #(acc.0, False, Number(current_number.x + 1, row, 0, ""))
      _ -> #(list.append(acc.0, [Number(current_number.x, row, 1, s)]), False, Number(current_number.x + 1, row, 0, ""))
    }
  })
  rslt.0
}
