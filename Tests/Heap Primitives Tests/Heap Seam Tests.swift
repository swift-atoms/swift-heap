import Buffer_Linear_Primitive
import Buffer_Primitive
import Buffer_Primitives_Test_Support
import Heap_Primitives
import Index_Primitives
import Memory_Allocator_Primitive
import Memory_Heap_Primitives
import Storage_Contiguous_Primitives
import Storage_Primitive
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
