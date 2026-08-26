import Testing

@testable import Heap

private struct SplitMix64: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { self.state = seed }
}

extension SplitMix64 {
    mutating func next() -> UInt64 {
        state = state &+ 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}

@Suite
struct `Heap Differential Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Heap Differential Tests`.Integration {
    @Test
    func `600 mixed ops: duplicates, interleaved push, pop, growth across reallocations`() {
        var rng = SplitMix64(seed: 0x5EED_1234_ABCD_0001)
        var heap = Heap<Int>()
        var oracle: [Int] = []

        let totalOps = 600
        var pushes = 0
        var interleavedPops = 0

        for _ in 0..<totalOps {

            let doPush = oracle.isEmpty || (Int(rng.next() % 100) < 58)
            if doPush {
                let value = Int(rng.next() % 40)
                heap.push(value)
                oracle.append(value)
                pushes += 1
            } else {
                let expected = oracle.min()!
                oracle.remove(at: oracle.firstIndex(of: expected)!)
                let got = heap.pop()
                #expect(got == expected)
                interleavedPops += 1
            }
        }

        oracle.sort()
        var tail: [Int] = []
        while let next = heap.pop() { tail.append(next) }
        #expect(tail == oracle)

        let overDrain = heap.pop()
        #expect(overDrain == nil)

        #expect(pushes + interleavedPops == totalOps)
        #expect(pushes >= 300)
        #expect(interleavedPops >= 100)
    }
}
