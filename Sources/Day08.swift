struct Day08: AdventDay {
  var data: String

  private struct DSU {
    var parent: [Int]
    var size: [Int]

    init(_ n: Int) {
      parent = Array(0..<n)
      size = Array(repeating: 1, count: n)
    }

    mutating func find(_ x: Int) -> Int {
      if parent[x] != x {
        parent[x] = find(parent[x])
      }
      return parent[x]
    }

    mutating func union(_ a: Int, _ b: Int) {
      let ra = find(a)
      let rb = find(b)
      if ra == rb { return }
      if size[ra] < size[rb] {
        parent[ra] = rb
        size[rb] += size[ra]
      } else {
        parent[rb] = ra
        size[ra] += size[rb]
      }
    }
  }

  func part1() async throws -> Int {
    let points: [(Int, Int, Int)] = data.split(whereSeparator: \.isNewline).compactMap { line in
      let parts = line.split(separator: ",")
      guard parts.count == 3,
        let x = Int(parts[0]),
        let y = Int(parts[1]),
        let z = Int(parts[2])
      else { return nil }
      return (x, y, z)
    }

    let n = points.count
    guard n >= 3 else { return n }

    var edges: [(Int, Int, Int)] = []
    edges.reserveCapacity(n * (n - 1) / 2)
    for i in 0..<n {
      let (xi, yi, zi) = points[i]
      for j in (i + 1)..<n {
        let (xj, yj, zj) = points[j]
        let dx = xi - xj
        let dy = yi - yj
        let dz = zi - zj
        let dist2 = dx * dx + dy * dy + dz * dz
        edges.append((dist2, i, j))
      }
    }

    edges.sort { $0.0 < $1.0 }

    var dsu = DSU(n)
    let connections = {
      if n <= 25 {
        return 10
      } else {
        return 1000
      }
    }()

    for (_, u, v) in edges.prefix(min(connections, edges.count)) {
      dsu.union(u, v)
    }

    var seen = Array(repeating: false, count: n)
    var sizes: [Int] = []
    for i in 0..<n {
      let r = dsu.find(i)
      if !seen[r] {
        seen[r] = true
        sizes.append(dsu.size[r])
      }
    }

    let topThree = sizes.sorted(by: >).prefix(3)
    return topThree.reduce(1, *)
  }
}
