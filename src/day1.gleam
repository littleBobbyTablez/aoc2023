import gleam/io
import simplifile
import gleam/result
import gleam/string
import gleam/list
import gleam/int

pub fn execute() {
  let assert input = simplifile.read("inputs/day1_part1.txt") |> result.unwrap("Something went wrong")

  io.println("Part 1 ===========================================")

  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(fn(l) { string.join([find_first_digit(l), find_first_digit(string.reverse(l))],"") })
  |> list.map(fn(x){ int.parse(x) |> result.unwrap(0)})
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> int.to_string()
  |> io.println()

  io.println("Part 2 ===========================================")

  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(fn(l) { string.join([find_first_number(l), find_last_number(l)],"")})
  |> list.map(fn(x){ int.parse(x) |> result.unwrap(0)})
  |> list.reduce(fn(acc, x) { acc + x })
  |> result.unwrap(0)
  |> int.to_string()
  |> io.println()

}

fn find_first_digit(s) {
  case s {
    "" -> "0"
    "1" <> _ -> "1"
    "2" <> _ -> "2"
    "3" <> _ -> "3"
    "4" <> _ -> "4"
    "5" <> _ -> "5"
    "6" <> _ -> "6"
    "7" <> _ -> "7"
    "8" <> _ -> "8"
    "9" <> _ -> "9"
    _ -> find_first_digit(string.drop_left(s, 1))
  }
}

fn find_last_number(s: String) {
  find_first_number(string.reverse(s))
}

fn find_first_number(s: String) {
  case s {
    "" -> "0"
    "one" <> _ -> "1"
    "two" <> _ -> "2"
    "three" <> _ -> "3"
    "four" <> _ -> "4"
    "five" <> _ -> "5"
    "six" <> _ -> "6"
    "seven" <> _ -> "7"
    "eight" <> _ -> "8"
    "nine" <> _ -> "9"
    "1" <> _ -> "1"
    "2" <> _ -> "2"
    "3" <> _ -> "3"
    "4" <> _ -> "4"
    "5" <> _ -> "5"
    "6" <> _ -> "6"
    "7" <> _ -> "7"
    "8" <> _ -> "8"
    "9" <> _ -> "9"
    "eno" <> _ -> "1"
    "owt" <> _ -> "2"
    "eerht" <> _ -> "3"
    "ruof" <> _ -> "4"
    "evif" <> _ -> "5"
    "xis" <> _ -> "6"
    "neves" <> _ -> "7"
    "thgie" <> _ -> "8"
    "enin" <> _ -> "9"
    _ -> find_first_number(string.drop_left(s, 1))
  }
}

