struct Day06: AdventDay {
  var data: String

  private func paddedLines() -> [String] {
    var rawLines = data.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    while let last = rawLines.last, last.allSatisfy({ $0 == " " }) {
      rawLines.removeLast()
    }
    guard let width = rawLines.map({ $0.count }).max() else { return [] }
    return rawLines.map { $0.padding(toLength: width, withPad: " ", startingAt: 0) }
  }

  private func columnGroups(lines: [String]) -> [Range<Int>] {
    guard let width = lines.first?.count else { return [] }
    var separator = Array(repeating: true, count: width)
    for c in 0..<width {
      for line in lines where line[line.index(line.startIndex, offsetBy: c)] != " " {
        separator[c] = false
        break
      }
    }

    var groups: [Range<Int>] = []
    var idx = 0
    while idx < width {
      while idx < width, separator[idx] { idx += 1 }
      if idx == width { break }
      let start = idx
      while idx < width, separator[idx] == false { idx += 1 }
      groups.append(start..<idx)
    }
    return groups
  }

  func part1() async throws -> Int {
    let lines = data.split(whereSeparator: \.isNewline).map(String.init)
    guard lines.count >= 2 else { return 0 }

    let operations = Array(lines.last!).filter { $0 == "+" || $0 == "*" }
    let numberRows: [[Int]] = lines.dropLast().map { line in
      line.split(whereSeparator: \.isWhitespace).compactMap { Int($0) }
    }

    var total = 0
    for (col, op) in operations.enumerated() {
      var values: [Int] = []
      for row in numberRows where col < row.count {
        values.append(row[col])
      }
      guard !values.isEmpty else { continue }
      let result = op == "+" ? values.reduce(0, +) : values.reduce(1, *)
      total += result
    }

    return total
  }

  func part2() async throws -> Int {
    let lines = paddedLines()
    guard lines.count >= 2 else { return 0 }

    let opRow = lines.last!
    let numberRows = Array(lines.dropLast())
    let groups = columnGroups(lines: lines)

    var total = 0

    for group in groups {
      let op: Character? = {
        for c in group {
          let ch = opRow[opRow.index(opRow.startIndex, offsetBy: c)]
          if ch == "+" || ch == "*" { return ch }
        }
        return nil
      }()
      guard let op else { continue }

      var values: [Int] = []
      for col in group {
        var digits: [Character] = []
        for row in numberRows {
          let ch = row[row.index(row.startIndex, offsetBy: col)]
          if ch.isWholeNumber { digits.append(ch) }
        }
        if !digits.isEmpty, let value = Int(String(digits)) {
          values.append(value)
        }
      }

      guard !values.isEmpty else { continue }
      let result = op == "+" ? values.reduce(0, +) : values.reduce(1, *)
      total += result
    }

    return total
  }
}
