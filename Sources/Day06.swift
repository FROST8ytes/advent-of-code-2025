struct Day06: AdventDay {
  var data: String

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
}
