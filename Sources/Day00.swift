import Algorithms

struct Day00: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { Int($0) }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async throws -> Int {
    entities.first?.reduce(0, +) ?? 0
  }

  func part2() async throws -> Int {
    entities.map { $0.max() ?? 0 }.reduce(0, +)
  }
}
