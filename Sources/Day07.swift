struct Day07: AdventDay {
  var data: String

  private func startPosition(lines: [String]) -> (row: Int, col: Int)? {
    for (r, line) in lines.enumerated() {
      if let c = Array(line).firstIndex(of: "S") {
        return (r, c)
      }
    }
    return nil
  }

  func part1() async throws -> Int {
    var lines = data.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    while lines.last == "" { lines.removeLast() }
    guard let start = startPosition(lines: lines) else { return 0 }

    var beams: Set<Int> = [start.col]
    var splits = 0

    for rowIndex in (start.row + 1)..<lines.count {
      let row = Array(lines[rowIndex])
      var next: Set<Int> = []

      for col in beams {
        guard col >= 0, col < row.count else { continue }
        let ch = row[col]
        if ch == "^" {
          splits += 1
          if col - 1 >= 0 { next.insert(col - 1) }
          if col + 1 < row.count { next.insert(col + 1) }
        } else {
          next.insert(col)
        }
      }

      beams = next
      if beams.isEmpty { break }
    }

    return splits
  }

  func part2() async throws -> Int {
    var lines = data.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    while lines.last == "" { lines.removeLast() }
    guard let start = startPosition(lines: lines) else { return 0 }

    let width = lines.first?.count ?? 0
    var counts = Array(repeating: 0, count: width)
    counts[start.col] = 1

    for rowIndex in (start.row + 1)..<lines.count {
      let row = Array(lines[rowIndex])
      var next = Array(repeating: 0, count: width)

      for col in 0..<width {
        let paths = counts[col]
        guard paths > 0 else { continue }
        guard col < row.count else { continue }
        if row[col] == "^" {
          if col - 1 >= 0 { next[col - 1] &+= paths }
          if col + 1 < width { next[col + 1] &+= paths }
        } else {
          next[col] &+= paths
        }
      }

      counts = next
      if counts.allSatisfy({ $0 == 0 }) { break }
    }

    return counts.reduce(0, +)
  }
}
