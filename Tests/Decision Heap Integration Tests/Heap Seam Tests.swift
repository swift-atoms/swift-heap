import Cardinal
import Heap
import Tagged
import Testing

@Suite
struct `Heap Seam Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Heap Seam Tests`.Integration {
    @Test
    func `canonical front door uses the growable linear column`() {
        let capacity = Tagged<Int, Cardinal>(_unchecked: Cardinal(UInt(4)))
        var heap = Heap::Heap<Int>(minimumCapacity: capacity)
        heap.push(7)
        heap.push(2)
        heap.push(5)

        #expect(heap.pop() == 2)
        #expect(heap.pop() == 5)
        #expect(heap.pop() == 7)
        #expect(heap.pop() == nil)
    }
}
