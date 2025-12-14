struct Day05: AdventDay {
  var data: String

  private typealias Range = (start: Int, end: Int)

  private var sections: (ranges: [Range], ids: [Int]) {
    let parts = data.split(separator: "\n\n", maxSplits: 1, omittingEmptySubsequences: false)
    let rangeLines = parts.first.map(String.init) ?? ""
    let idLines = parts.count > 1 ? String(parts[1]) : ""

    let ranges: [Range] = rangeLines.split(whereSeparator: { $0.isNewline }).compactMap { line in
      let tokens = line.split(separator: "-")
      guard tokens.count == 2, let start = Int(tokens[0]), let end = Int(tokens[1]) else { return nil }
      return (start: start, end: end)
    }

    let ids: [Int] = idLines.split(whereSeparator: { $0.isNewline }).compactMap { Int($0) }
    return (ranges, ids)
  }

  private func merged(_ ranges: [Range]) -> [Range] {
    guard !ranges.isEmpty else { return [] }
    let sorted = ranges.sorted { lhs, rhs in
      if lhs.start == rhs.start { return lhs.end < rhs.end }
      return lhs.start < rhs.start
    }

    var merged: [Range] = []
    var current = sorted[0]
    for range in sorted.dropFirst() {
      if range.start <= current.end {
        current.end = max(current.end, range.end)
      } else {
        merged.append(current)
        current = range
      }
    }
    merged.append(current)
    return merged
  }

  private func contains(_ value: Int, in ranges: [Range]) -> Bool {
    var low = 0
    var high = ranges.count
    while low < high {
      let mid = (low + high) / 2
      let range = ranges[mid]
      if value < range.start {
        high = mid
      } else if value > range.end {
        low = mid + 1
      } else {
        return true
      }
    }
    return false
  }

  func part1() async throws -> Int {
    let parsed = sections
    let mergedRanges = merged(parsed.ranges)
    var count = 0
    for id in parsed.ids {
      if contains(id, in: mergedRanges) {
        count += 1
      }
    }
    return count
  }
}
