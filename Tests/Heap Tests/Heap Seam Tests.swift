import Buffer_Linear_Primitive
import Buffer
import Buffer_Test_Support
import Heap
import Index
import Memory_Allocator
import Memory_Heap
import Storage
import Storage
import Testing

private typealias HeapColumn<E: ~Copyable> =
    Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear

@Suite
struct `Heap Seam Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Heap Seam Tests`.Integration {
    @Test
    func `DS-024 Seam Ledger laws hold for the canonical Heap column`() {
        let violations = Seam.Ledger.violations(
            makeEmpty: { HeapColumn<Int>(minimumCapacity: Index<Int>.Count(4)) },
            element: { $0 }
        )
        #expect(violations.isEmpty, "\(violations)")
    }
}
