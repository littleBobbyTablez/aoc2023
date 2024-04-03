import gleeunit
import gleeunit/should
import gleam/string
import gleam/io
import gleam/list
import gleam/result

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  ["ab"]
  |> list.map(fn(l) { to_int(l, string.first) + to_int(l, string.last)})
  |> io.debug()
}

pub fn text_to_number_test() {
  // let digits_in_text = dict.from_list([#("one", 1), #("two", 2), #("three", 3), #("four", 4), #("five", 5), #("six", 6), #("seven", 7), #("eight", 8), #("nine", 9), #("zero", 0)])
  let s = "blonesiowel"
  let i = 3

  find_first_number(s, i)
  |> should.equal(1)


  let second = "twoone"
  find_first_number(second, i)
  |> should.equal(2)

  let third = "nothing"
  find_first_number(third, i)
  |> should.equal(3)
}

fn find_first_number(s: String, i: Int) {
  case s {
    "" -> i
    "one" <> _ -> 1
    "two" <> _ -> 2
    "three" <> _ -> 3
    "four" <> _ -> 4
    "five" <> _ -> 5
    "six" <> _ -> 6
    "seven" <> _ -> 7
    "eight" <> _ -> 8
    "nine" <> _ -> 9
    "1" <> _ -> 1
    "2" <> _ -> 2
    "3" <> _ -> 3
    "4" <> _ -> 4
    "5" <> _ -> 5
    "6" <> _ -> 6
    "7" <> _ -> 7
    "8" <> _ -> 8
    "9" <> _ -> 9
    "eno" <> _ -> 1
    "owt" <> _ -> 2
    "eerht" <> _ -> 3
    "ruof" <> _ -> 4
    "evif" <> _ -> 5
    "xis" <> _ -> 6
    "neves" <> _ -> 7
    "thgie" <> _ -> 8
    "enin" <> _ -> 9
    _ -> find_first_number(string.drop_left(s, 1), i)
  }
}


fn to_int(s: String, func: fn(String) -> Result(String, b)) -> Int {
  func(s)
    |> result.unwrap("")
    |> string.to_utf_codepoints()
    |> list.first
    |> result.unwrap( string.utf_codepoint(0) |> unwrap_utfcp)
    |> string.utf_codepoint_to_int()
}

fn unwrap_utfcp(r: Result(UtfCodepoint, Nil)) {
  case r {
    Ok(x) -> x
    Error(_) -> panic
  }
}
