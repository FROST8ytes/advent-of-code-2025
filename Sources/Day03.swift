struct Day03: AdventDay {
  var data: String

  private func maxPairValue(_ digits: [Int]) -> Int {
    guard digits.count >= 2 else { return 0 }

    var suffixMax = Array(repeating: -1, count: digits.count + 1)
    for i in stride(from: digits.count - 1, through: 0, by: -1) {
      suffixMax[i] = max(digits[i], suffixMax[i + 1])
    }

    var best = 0
    for i in 0..<(digits.count - 1) {
      let tens = digits[i]
      let ones = suffixMax[i + 1]
      guard ones >= 0 else { continue }
      best = max(best, tens * 10 + ones)
    }

    return best
  }

  func part1() async throws -> Int {
    var total = 0

    for line in data.split(whereSeparator: { $0.isNewline }) {
      let digits = line.compactMap { $0.wholeNumberValue }
      total += maxPairValue(digits)
    }

    return total
  }
}
