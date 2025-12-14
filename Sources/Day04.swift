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

  func part2() async throws -> Int {
    let rows = grid
    let height = rows.count
    guard let width = rows.first?.count else { return 0 }

    var active = Array(repeating: Array(repeating: false, count: width), count: height)
    var neighborCount = Array(repeating: Array(repeating: 0, count: width), count: height)

    for r in 0..<height {
      for c in 0..<width {
        if rows[r][c] == "@" {
          active[r][c] = true
        }
      }
    }

    for r in 0..<height {
      for c in 0..<width where active[r][c] {
        var count = 0
        for (dr, dc) in directions {
          let nr = r + dr
          let nc = c + dc
          if nr >= 0, nr < height, nc >= 0, nc < width, active[nr][nc] {
            count += 1
          }
        }
        neighborCount[r][c] = count
      }
    }

    var queue: [(Int, Int)] = []
    queue.reserveCapacity(height * width)
    for r in 0..<height {
      for c in 0..<width where active[r][c] {
        if neighborCount[r][c] < 4 {
          queue.append((r, c))
        }
      }
    }

    var removed = 0
    var head = 0
    while head < queue.count {
      let (r, c) = queue[head]
      head += 1
      guard active[r][c], neighborCount[r][c] < 4 else { continue }

      active[r][c] = false
      removed += 1

      for (dr, dc) in directions {
        let nr = r + dr
        let nc = c + dc
        if nr >= 0, nr < height, nc >= 0, nc < width, active[nr][nc] {
          neighborCount[nr][nc] -= 1
          if neighborCount[nr][nc] == 3 {
            queue.append((nr, nc))
          }
        }
      }
    }

    return removed
  }
}
