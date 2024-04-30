import simplifile
import gleam/result
import gleam/io
import gleam/string
import gleam/int
import gleam/list
import gleam/dict

pub type Hand {
  FiveOfAKind
  FourOfAKind
  FullHouse
  ThreeOfAKind
  TwoPair
  OnePair
  HighCard
}

pub fn execute() {

  let assert input = simplifile.read("inputs/day7.txt") |> result.unwrap("Something went wrong")

  let hands = input
  |> string.trim()
  |> string.split("\n")
  |> list.map(fn(c) {
      let l = string.split(c, " ")
      let cards = list.first(l) |> result.unwrap("")
      let value = list.drop(l, 1) |> list.first() |> result.unwrap("") |> int.parse() |> result.unwrap(0)
      #(cards, value)
    })


  let card_types = "AKQJT98765432"
    |> string.split("")

  let card_types_with_joker = "AKQT98765432J"
    |> string.split("")


  let card_order = card_types
    |> list.zip(list.range(1, list.length(card_types)))
    |> dict.from_list()

  let card_order_with_joker = card_types_with_joker
    |> list.zip(list.range(1, list.length(card_types)))
    |> dict.from_list()

  io.println("Part 1 ================================================")

  let ordered_by_hand = hands
  |> list.group(fn(h) { categorize_hand(h.0) })
  |> dict.map_values(fn(_, v) {
    let ordered = v |> sort_hands(card_order)
     ordered
    })

  let ordered = ordered_by_hand |> dict.to_list |> list.sort(fn(a, b) {
      compare_hand_type(a.0, b.0)
    })
  |> list.map(fn(x) { x.1 })
  |> list.flatten()

  ordered
  |> list.map( fn(x) { x.1 })
  |> list.zip( list.range(list.length(ordered), 1))
  |> list.map(fn(b) { b.0 * b.1 })
  |> list.reduce(fn(x, y){ x + y })
  |> result.unwrap(0)
  |> int.to_string()
  |> io.println()


  io.println("Part 2 ================================================")

  let ordered_by_hand_with_joker = hands
  |> list.group(fn(h) { categorize_hand_with_joker(h.0) })
  |> dict.map_values(fn(_, v) {
    let ordered = v |> sort_hands(card_order_with_joker)
     ordered
    })

  let ordered_with_joker = ordered_by_hand_with_joker |> dict.to_list |> list.sort(fn(a, b) {
      compare_hand_type(a.0, b.0)
    })
  |> list.map(fn(x) { x.1 })
  |> list.flatten()

  ordered_with_joker
  |> list.map( fn(x) { x.1 })
  |> list.zip( list.range(list.length(ordered), 1))
  |> list.map(fn(b) { b.0 * b.1 })
  |> list.reduce(fn(x, y){ x + y })
  |> result.unwrap(0)
  |> int.to_string()
  |> io.println()

}

pub fn sort_hands(l: List(#(String, Int)), card_order: dict.Dict(String, Int)) {
  l
  |> list.sort(fn(a, b) {
      compare_hands(a, b, card_order)
    })
}

pub fn compare_hands(a: #(String, Int), b: #(String, Int), card_order: dict.Dict(String, Int)) {
  let first = string.first(a.0) |> result.unwrap("") |> dict.get(card_order, _) |> result.unwrap(-1)
  let second = string.first(b.0)|> result.unwrap("") |> dict.get(card_order, _) |> result.unwrap(-1)
  case first != second {
    True -> int.compare(first, second)
    False if first == -1 -> int.compare(first, second)
    _ -> compare_hands(#(string.drop_left(a.0, 1), a.1), #(string.drop_left(b.0, 1), b.1), card_order)
  }
}

pub fn compare_hand_type(a: Hand, b: Hand) {
  int.compare(type_to_int(a), type_to_int(b))
}

pub fn type_to_int(h: Hand) {
  case h {
    FiveOfAKind -> 1
    FourOfAKind -> 2
    FullHouse -> 3
    ThreeOfAKind -> 4
    TwoPair -> 5
    OnePair -> 6
    HighCard -> 7
  }
}

pub fn categorize_hand(h: String) {
  let l = h |> string.split("") |> list.group( fn(c) { c } )
  let grouped = l |> dict.to_list() |> list.map(fn(x) { #(x.0, list.length(x.1)) } )

  case list.length(grouped) {

    1 -> FiveOfAKind
    2 -> {
      let first = grouped |> list.first() |> result.unwrap(#("",0))
      case first.1 {
        2 -> FullHouse
        3 -> FullHouse
        _ -> FourOfAKind
        }
    }
    3 -> {
      case grouped |> list.map(fn(x) { x.1 }) |> list.contains(3) {
          True -> ThreeOfAKind
          False -> TwoPair
        }
      }
    4 -> OnePair
    _ -> HighCard
  }
}

pub fn categorize_hand_with_joker(h: String) {
  let l = h |> string.split("") |> list.group( fn(c) { c } )

  let joker_list = l |> dict.get("J")

  let joker_count = case joker_list {
    Ok(x) -> list.length(x)
    Error(_) -> 0
  }

  let grouped = l |> dict.to_list() |> list.map(fn(x) { #(x.0, list.length(x.1)) } )

  case list.length(grouped) {

    1 -> FiveOfAKind
    2 if joker_count == 0 -> {
      let first = grouped |> list.first() |> result.unwrap(#("",0))
      case first.1 {
        2 -> FullHouse
        3 -> FullHouse
        _ -> FourOfAKind
        }
    }
    2 -> FiveOfAKind
    3 if joker_count == 0 -> {
      case grouped |> list.map(fn(x) { x.1 }) |> list.contains(3) {
          True -> ThreeOfAKind
          False -> TwoPair
        }
      }
    3 -> {
      case grouped |> list.map(fn(x) { x.1 }) |> list.contains(3) {
          True -> FourOfAKind
          False if joker_count == 2 || joker_count == 3 -> FourOfAKind
          _ -> FullHouse
        }
      }
    4 if joker_count == 0 -> OnePair
    4 -> ThreeOfAKind
    5 if joker_count == 1 -> OnePair
    _ -> HighCard
  }
}
