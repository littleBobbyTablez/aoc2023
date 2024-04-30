import gleeunit
import gleeunit/should
import day7
import gleam/io
import gleam/string
import gleam/list
import gleam/dict

pub fn main() {
  gleeunit.main()
}

pub fn categorize_test() {
  "TTTTT"
  |> day7.categorize_hand()
  |> should.equal(day7.FiveOfAKind)

  "TTTT3"
  |> day7.categorize_hand()
  |> should.equal(day7.FourOfAKind)

  "A3A3A"
  |> day7.categorize_hand()
  |> should.equal(day7.FullHouse)

  "23456"
  |> day7.categorize_hand()
  |> should.equal(day7.HighCard)

  "22334"
  |> day7.categorize_hand()
  |> should.equal(day7.TwoPair)

  "33356"
  |> day7.categorize_hand()
  |> should.equal(day7.ThreeOfAKind)

  "66789"
  |> day7.categorize_hand()
  |> should.equal(day7.OnePair)
}

pub fn sort_test() {
   let card_types = "AKQJT98765432"
      |> string.split("")

    let card_order = card_types
      |> list.zip(list.range(1, list.length(card_types)))
      |> dict.from_list()


  [#("T55J5", 684), #("QQQJA", 483)]
  |> day7.sort_hands(card_order)
  |> io.debug()



}
