struct Day03: AdventDay {
  var data: String

  private func bestNumber(_ digits: [Int], length: Int) -> Int {
    guard digits.count >= length else { return 0 }

    var toRemove = digits.count - length
    var stack: [Int] = []

    for (index, digit) in digits.enumerated() {
      let remaining = digits.count - index - 1
      while toRemove > 0,
        let last = stack.last,
        last < digit,
        stack.count + remaining >= length
      {
        stack.removeLast()
        toRemove -= 1
      }
      stack.append(digit)
    }

    if stack.count > length {
      stack.removeLast(stack.count - length)
    }

    return stack.reduce(0) { $0 * 10 + $1 }
  }

  func part1() async throws -> Int {
    var total = 0

    for line in data.split(whereSeparator: { $0.isNewline }) {
      let digits = line.compactMap { $0.wholeNumberValue }
      total += bestNumber(digits, length: 2)
    }

    return total
  }

  func part2() async throws -> Int {
    var total = 0

    for line in data.split(whereSeparator: { $0.isNewline }) {
      let digits = line.compactMap { $0.wholeNumberValue }
      total += bestNumber(digits, length: 12)
    }

    return total
  }
}
