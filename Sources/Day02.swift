struct Day02: AdventDay {
  var data: String

  private typealias Range = (start: Int, end: Int)

  private var ranges: [Range] {
    data.split(separator: ",").compactMap { raw in
      let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !trimmed.isEmpty else { return nil }
      let parts = trimmed.split(separator: "-")
      guard parts.count == 2,
        let start = Int(parts[0]),
        let end = Int(parts[1])
      else { return nil }
      return (start: start, end: end)
    }
  }

    private func repeatedNumbers(upTo maxValue: Int, minRepeats: Int = 2, maxRepeats: Int? = nil) -> [Int] {
      let maxDigits = String(maxValue).count
      // Precompute powers of 10 to avoid pow(Double).
      var pow10: [Int] = [1]
      for _ in 1...maxDigits {
        pow10.append(pow10.last! * 10)
      }

      func repFactor(length: Int, repeats: Int) -> Int {
        // (10^(length*repeats) - 1) / (10^length - 1)
        let numerator = pow10[length * repeats] - 1
        let denominator = pow10[length] - 1
        return numerator / denominator
      }

      var result: Set<Int> = []
      let maxBaseLength = maxDigits / minRepeats

      for length in 1...maxBaseLength {
        let baseStart = pow10[length - 1]
        let baseEnd = pow10[length] - 1
        let maxRepeatCount = min(maxDigits / length, maxRepeats ?? Int.max)

        for repeatCount in minRepeats...maxRepeatCount {
          let factor = repFactor(length: length, repeats: repeatCount)
          for base in baseStart...baseEnd {
            let value = base * factor
            if value > maxValue {
              break
            }
            result.insert(value)
          }
        }
      }

      return Array(result)
    }

  private func lowerBound(_ values: [Int], target: Int) -> Int {
    var low = 0
    var high = values.count
    while low < high {
      let mid = (low + high) / 2
      if values[mid] < target {
        low = mid + 1
      } else {
        high = mid
      }
    }
    return low
  }

  private func upperBound(_ values: [Int], target: Int) -> Int {
    var low = 0
    var high = values.count
    while low < high {
      let mid = (low + high) / 2
      if values[mid] <= target {
        low = mid + 1
      } else {
        high = mid
      }
    }
    return low
  }

    func part1() async throws -> Int {
      let maxEnd = ranges.map(\.end).max() ?? 0
      let invalids = repeatedNumbers(upTo: maxEnd, minRepeats: 2, maxRepeats: 2).sorted()

    var prefix: [Int] = Array(repeating: 0, count: invalids.count + 1)
    for (index, value) in invalids.enumerated() {
      prefix[index + 1] = prefix[index] + value
    }

    var total = 0
    for range in ranges {
      let lower = lowerBound(invalids, target: range.start)
      let upper = upperBound(invalids, target: range.end)
      if lower < upper {
        total += prefix[upper] - prefix[lower]
      }
    }

    return total
  }

    func part2() async throws -> Int {
      let maxEnd = ranges.map(\.end).max() ?? 0
      let invalids = repeatedNumbers(upTo: maxEnd).sorted()

      var prefix: [Int] = Array(repeating: 0, count: invalids.count + 1)
      for (index, value) in invalids.enumerated() {
        prefix[index + 1] = prefix[index] + value
      }

      var total = 0
      for range in ranges {
        let lower = lowerBound(invalids, target: range.start)
        let upper = upperBound(invalids, target: range.end)
        if lower < upper {
          total += prefix[upper] - prefix[lower]
        }
      }

      return total
    }
}
