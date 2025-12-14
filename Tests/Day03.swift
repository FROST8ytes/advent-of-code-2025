import Testing

@testable import AdventOfCode

struct Day03Tests {
  let testData = """
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """

  @Test func testPart1() async throws {
    let challenge = Day03(data: testData)
    #expect(try await challenge.part1() == 357)
  }
}
