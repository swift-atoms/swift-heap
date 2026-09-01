public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Buffer_Protocol
import Comparison
public import Index
public import Memory_Allocator
public import Memory_Allocator_Protocol
public import Storage_Contiguous
public import Storage_Primitive
public import Store_Protocol

@_documentation(visibility: public)
@frozen
public struct __Heap<S: ~Copyable>: ~Copyable {

    @usableFromInline
    package var column: S

    @inlinable
    public init(column: consuming S) { self.column = column }
}

extension __Heap where S: ~Copyable {

    @inlinable
    public consuming func take() -> S { column }
}

extension __Heap: Copyable where S: Copyable {}
extension __Heap: Sendable where S: Sendable & ~Copyable {}

extension __Heap where S: ~Copyable, S: Store.`Protocol` & Buffer.`Protocol` {

    @inlinable
    public var count: Index<S.Element>.Count { column.count }

    @inlinable
    public var isEmpty: Bool { column.isEmpty }

    @inlinable
    public var min: S.Element {
        _read { yield column[0] }
    }
}

extension __Heap
where
    S: ~Copyable,
    S: Store.`Protocol` & Buffer.`Protocol`,
    S.Element: Comparison.`Protocol`
{

    @inlinable
    package func slot(_ k: Int) -> Index<S.Element> {
        Index(Ordinal(UInt(k)))
    }

    @inlinable
    package mutating func exchange(_ i: Index<S.Element>, _ j: Index<S.Element>) {
        column.swapAt(i, j)
    }

    @inlinable
    package mutating func siftUp(from k: Int) {
        var child = k
        while child > 0 {
            let parent = (child - 1) / 2
            guard column[slot(child)] < column[slot(parent)] else { break }
            exchange(slot(child), slot(parent))
            child = parent
        }
    }

    @inlinable
    package mutating func siftDown(over n: Int) {
        var parent = 0
        while true {
            let l = 2 * parent + 1
            let r = l + 1
            var smallest = parent
            if l < n, column[slot(l)] < column[slot(smallest)] { smallest = l }
            if r < n, column[slot(r)] < column[slot(smallest)] { smallest = r }
            if smallest == parent { return }
            exchange(slot(parent), slot(smallest))
            parent = smallest
        }
    }

    @inlinable
    public mutating func pop() -> S.Element? {
        let n = Int(clamping: count)
        if n == 0 { return nil }
        column.unshare()
        if n == 1 { return column.move(at: slot(0)) }

        column.swapAt(slot(0), slot(n - 1))
        let root = column.move(at: slot(n - 1))
        siftDown(over: n - 1)
        return root
    }
}

extension __Heap where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Index<E>.Count = Index<E>.Count(4)
    ) where S == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Linear {
        self.init(column: S(minimumCapacity: minimumCapacity))
    }

    @inlinable
    public mutating func push<
        E: ~Copyable & Comparison.`Protocol`,
        Resource: Memory.Growable & ~Copyable
    >(
        _ element: consuming E
    ) where S == Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Linear {
        column.append(element)

        siftUp(from: Int(clamping: count) - 1)
    }
}
