import Testing

@testable import AdventOfCode

struct Day04Tests {
  let testData = """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """

  @Test func testPart1() async throws {
    let challenge = Day04(data: testData)
    #expect(try await challenge.part1() == 13)
  }
}
