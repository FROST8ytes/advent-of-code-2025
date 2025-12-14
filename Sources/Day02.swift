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

  private func repeatedNumbers(upTo maxValue: Int) -> [Int] {
    var result: [Int] = []
    var powerOfTen = 1

    while true {
      let halfMin = powerOfTen
      let nextPower = powerOfTen * 10
      let halfMax = nextPower - 1
      let multiplier = nextPower

      // If the smallest possible repeated number for this length exceeds the cap, stop.
      if halfMin * multiplier + halfMin > maxValue {
        break
      }

      for half in halfMin...halfMax {
        let value = half * multiplier + half
        if value > maxValue {
          break
        }
        result.append(value)
      }

      powerOfTen = nextPower
    }

    return result
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
