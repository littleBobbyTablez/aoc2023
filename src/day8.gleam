import simplifile
import gleam/result
import gleam/io
import gleam/string
import gleam/list
import gleam/dict
import gleam/int

pub type Node {
  Node(left: String, right: String)
}

pub fn execute() {

  let assert input = simplifile.read("inputs/day8.txt") |> result.unwrap("Something went wrong")


  let lines = input
  |> string.trim()
  |> string.split("\n")

  let instructions = lines |> list.first() |> result.unwrap("") |> string.split("")

  let nodes = lines |> list.drop(2) |> list.map( fn(l) {
      let split = l |> string.drop_right(1) |> string.split(" = (")
      let node_list = split |> list.drop(1) |> list.first() |> result.unwrap("") |> string.split(", ")
      #(split |> list.first() |> result.unwrap(""), Node(node_list |> list.first() |> result.unwrap(""), node_list |> list.drop(1) |> list.first() |> result.unwrap("")))
    })
    |> dict.from_list()

  io.println("Part 1 ================================================")
  follow_instructions("AAA", instructions, instructions, nodes, 0)
  |> int.to_string()
  |> io.println()

  io.println("Part 2 ================================================")

  let starting_nodes = nodes |> dict.keys() |> list.filter( fn(k) {
    k |> string.ends_with("A")
  })

  starting_nodes
  |> list.map(fn(n) {
    follow_all_instructions(n, instructions, instructions, nodes, 0)
  })
  |> list.reduce( fn(a, b) { lcm(a,b) })
  |> result.unwrap(0)
  |> int.to_string()
  |> io.println()


}

pub fn follow_instructions(current: String, instructions: List(String), instruction_set: List(String), nodes: dict.Dict(String, Node), count: Int) {
  case current {
    "ZZZ" -> count
    x -> {
      let node = nodes |> dict.get(x) |> result.unwrap(Node("", ""))
      let next = case instructions |> list.first() |> result.unwrap("") {
        "R" -> node.right
        "L" -> node.left
        _ -> panic
      }
      let remaining_instructions = instructions |> list.drop(1)
      let new_instructions = case remaining_instructions {
        [] -> instruction_set
        _ -> remaining_instructions
      }
      follow_instructions(next, new_instructions, instruction_set, nodes , count + 1)
    }
  }
}

pub fn follow_all_instructions(current: String, instructions: List(String), instruction_set: List(String), nodes: dict.Dict(String, Node), count: Int) {

  case string.ends_with(current, "Z") {
    True -> count
    False -> {
      let node = nodes |> dict.get(current) |> result.unwrap(Node("", ""))
      let next = case instructions |> list.first() |> result.unwrap("") {
        "R" -> node.right
        "L" -> node.left
        _ -> panic
      }
      let remaining_instructions = instructions |> list.drop(1)
      let new_instructions = case remaining_instructions {
        [] -> instruction_set
        _ -> remaining_instructions
      }
      follow_all_instructions(next, new_instructions, instruction_set, nodes , count + 1)
    }
  }
}

fn lcm(a: Int, b: Int) {
  let m = a*b
  m / find_gdc(a, b)
}

fn find_gdc(a: Int, b: Int) {
  case b == 0 {
    True -> a
    False -> {
      case a == 0 {
        True -> b
        False if a > b -> find_gdc(a - b, b)
        _ -> find_gdc(a , b - a)
      }
    }
  }


}
