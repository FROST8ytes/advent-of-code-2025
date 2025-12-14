struct Day04: AdventDay {
  var data: String

  private var grid: [[Character]] {
    data.split(whereSeparator: { $0.isNewline }).map(Array.init)
  }

  private let directions: [(Int, Int)] = [
    (-1, -1), (-1, 0), (-1, 1),
    (0, -1),          (0, 1),
    (1, -1),  (1, 0), (1, 1)
  ]

  func part1() async throws -> Int {
    let rows = grid
    guard let width = rows.first?.count else { return 0 }

    var total = 0
    for r in 0..<rows.count {
      for c in 0..<width {
        guard rows[r][c] == "@" else { continue }
        var adjacentRolls = 0
        for (dr, dc) in directions {
          let nr = r + dr
          let nc = c + dc
          if nr >= 0, nr < rows.count, nc >= 0, nc < width, rows[nr][nc] == "@" {
            adjacentRolls += 1
          }
        }
        if adjacentRolls < 4 {
          total += 1
        }
      }
    }

    return total
  }
}
