struct Day01: AdventDay {
  var data: String

  private struct Rotation {
    enum Direction {
      case left
      case right
    }

    let direction: Direction
    let steps: Int
  }

  private var rotations: [Rotation] {
    data.split(separator: "\n").compactMap { line in
      guard let directionToken = line.first else { return nil }
      let direction: Rotation.Direction
      switch directionToken {
      case "L": direction = .left
      case "R": direction = .right
      default: return nil
      }
      guard let distance = Int(line.dropFirst()) else { return nil }
      return Rotation(direction: direction, steps: distance)
    }
  }

  func part1() async throws -> Int {
    var position = 50
    var zeroHits = 0

    for rotation in rotations {
      let offset = rotation.steps % 100
      let signedOffset = rotation.direction == .left ? -offset : offset
      position = (position + signedOffset) % 100
      if position < 0 { position += 100 }
      if position == 0 { zeroHits += 1 }
    }

    return zeroHits
  }
}
