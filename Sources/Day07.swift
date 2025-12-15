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
    let lines = data.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
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
}
