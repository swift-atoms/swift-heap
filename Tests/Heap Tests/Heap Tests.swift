import Comparison
import Index
import Storage
import Testing

@testable import Heap
import Heap_Test_Support

private struct Job: ~Copyable, Comparison.`Protocol` {
    let priority: Int
    init(_ priority: Int) { self.priority = priority }
}

extension Job {
    static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.priority < rhs.priority
    }
    static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.priority == rhs.priority
    }
}

@Suite
struct `Heap Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Heap Tests`.Unit {
    @Test
    func `empty heap reports isEmpty and count 0`() {
        let heap = InlineHeap<Int, 128>(column: Store.Inline())
        let empty = heap.isEmpty
        let count = heap.count
        #expect(empty)
        #expect(count == Index<Int>.Count(0))
    }

    @Test
    func `push then pop yields elements in ascending (min-first) order`() {
        var heap = InlineHeap<Int, 128>(column: Store.Inline())
        for value in [42, 3, 25, 7, 3, 19] { heap.push(value) }
        let nonEmpty = !heap.isEmpty
        let count = heap.count
        let minimum = heap.min
        #expect(nonEmpty)
        #expect(count == Index<Int>.Count(6))
        #expect(minimum == 3)

        var drained: [Int] = []
        while let next = heap.pop() { drained.append(next) }
        let empty = heap.isEmpty
        let overDrain = heap.pop()
        #expect(drained == [3, 3, 7, 19, 25, 42])
        #expect(empty)
        #expect(overDrain == nil)
    }

    @Test
    func `min tracks the running minimum as elements arrive`() {
        var heap = InlineHeap<Int, 128>(column: Store.Inline())
        heap.push(9)
        let m0 = heap.min
        #expect(m0 == 9)
        heap.push(4)
        let m1 = heap.min
        #expect(m1 == 4)
        heap.push(8)
        let m2 = heap.min
        #expect(m2 == 4)
        heap.push(1)
        let m3 = heap.min
        #expect(m3 == 1)
        let popped = heap.pop()
        let m4 = heap.min
        #expect(popped == 1)
        #expect(m4 == 4)
    }

    @Test
    func `Move-only elements flow through push, pop, and min`() {
        var heap = InlineHeap<Job, 8>(column: Store.Inline())
        heap.push(Job(5))
        heap.push(Job(1))
        heap.push(Job(3))
        let peeked = heap.min.priority
        #expect(peeked == 1)

        var priorities: [Int] = []
        while let job = heap.pop() { priorities.append(job.priority) }
        let empty = heap.isEmpty
        #expect(priorities == [1, 3, 5])
        #expect(empty)
    }
}

extension `Heap Tests`.`Edge Case` {
    @Test
    func `reading minimum from an empty heap traps`() async {
        await #expect(processExitsWith: .failure) {
            let heap = InlineHeap<Int, 1>(column: Store.Inline())
            _ = heap.min
        }
    }

    @Test
    func `pushing beyond column capacity traps`() async {
        await #expect(processExitsWith: .failure) {
            var heap = InlineHeap<Int, 1>(column: Store.Inline())
            heap.push(1)
            heap.push(2)
        }
    }

    @Test
    func `single element heap: push, min, pop`() {
        var heap = InlineHeap<Int, 8>(column: Store.Inline())
        heap.push(17)
        let count = heap.count
        let minimum = heap.min
        #expect(count == Index<Int>.Count(1))
        #expect(minimum == 17)
        let popped = heap.pop()
        let empty = heap.isEmpty
        #expect(popped == 17)
        #expect(empty)
        let overDrain = heap.pop()
        #expect(overDrain == nil)
    }

    @Test
    func `filling inline capacity preserves the heap invariant`() {
        var heap = InlineHeap<Int, 64>(column: Store.Inline())

        for value in stride(from: 64, through: 1, by: -1) { heap.push(value) }
        let count = heap.count
        #expect(count == Index<Int>.Count(64))
        var previous = Int.min
        while let next = heap.pop() {
            #expect(next >= previous)
            previous = next
        }
    }
}
