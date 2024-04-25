import gleeunit
import gleeunit/should
import day5

pub fn main() {
  gleeunit.main()
}

pub fn relation_test(){
  let sut = day5.Entry(10, 10, 10)
  let map = day5.Entry(30, 8, 20)

  day5.calculate_relation(sut, map)
  |> should.equal(day5.Contained)
}

pub fn transform_contains_test() {
  let sut = day5.Entry(0, 10, 10)

  let map1 = day5.Entry(30, 5, 20)

  day5.transform(sut, [], [map1])
  |> should.equal([day5.Entry(0, 35, 10)])
}

pub fn transform_nothing_test() {
  let sut = day5.Entry(0, 10, 10)

  let map1 = day5.Entry(30, 25, 20)

  day5.transform(sut, [], [map1])
  |> should.equal([day5.Entry(0, 10, 10)])

}

pub fn transform_intersect_smaller_test() {
  let sut = day5.Entry(0, 10, 10)

  let map1 = day5.Entry(30, 15, 10)

  day5.transform(sut, [], [map1])
  |> should.equal([day5.Entry(0, 10, 5), day5.Entry(0, 30, 5)])

}

pub fn transform_intersect_greater_test() {
  let sut = day5.Entry(0, 10, 10)

  let map1 = day5.Entry(30, 5, 10)

  day5.transform(sut, [], [map1])
  |> should.equal([day5.Entry(0, 15, 5), day5.Entry(0, 35, 5)])

}

pub fn transform_intersect_contains_test() {
  let sut = day5.Entry(0, 10, 10)

  let map1 = day5.Entry(30, 15, 10)
  let map2 = day5.Entry(50, 10, 10)

  day5.transform(sut, [], [map1, map2])

  |> should.equal([day5.Entry(0, 30, 5), day5.Entry(0, 50, 5)])

}

pub fn transform_intersect_nothing_test() {
  let sut = day5.Entry(0, 10, 10)

  let map1 = day5.Entry(30, 15, 10)
  let map2 = day5.Entry(50, 25, 10)

  day5.transform(sut, [], [map1, map2])

  |> should.equal([day5.Entry(0, 30, 5), day5.Entry(0, 10, 5)])

}
