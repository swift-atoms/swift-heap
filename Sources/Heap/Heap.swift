public import Comparison
public import Index
public import Storage

public typealias Heap<Column: ~Copyable> = __Heap<Column>

@_documentation(visibility: public)
@frozen
public struct __Heap<S: ~Copyable>: ~Copyable {

    @usableFromInline
    package var column: S

    @inlinable
    public init(column: consuming S) {
        self.column = column
    }
}

extension __Heap where S: ~Copyable {

    @inlinable
    public consuming func take() -> S {
        column
    }
}

extension __Heap: Copyable where S: Copyable {}
extension __Heap: Sendable where S: Sendable & ~Copyable {}

extension __Heap where S: Store.Ledgered.`Protocol` & ~Copyable {

    @inlinable
    public var count: Index<S.Element>.Count {
        column.initialization.count
    }

    @inlinable
    public var isEmpty: Bool {
        column.initialization.isEmpty
    }

    @inlinable
    public var min: S.Element {
        _read {
            precondition(!isEmpty, "Cannot read the minimum of an empty heap")
            yield column[slot(0)]
        }
    }

    @inlinable
    package func slot(_ offset: Int) -> Index<S.Element> {
        precondition(offset >= 0, "Heap slot must be nonnegative")
        return Index(UInt(offset))
    }
}

extension __Heap
where
    S: Store.Ledgered.`Protocol` & ~Copyable,
    S.Element: Comparison.`Protocol`
{

    @inlinable
    package mutating func exchange(_ i: Index<S.Element>, _ j: Index<S.Element>) {
        column.swapAt(i, j)
    }

    @inlinable
    package mutating func siftUp(from offset: Int) {
        var child = offset
        while child > 0 {
            let parent = (child - 1) / 2
            guard column[slot(child)] < column[slot(parent)] else {
                break
            }
            exchange(slot(child), slot(parent))
            child = parent
        }
    }

    @inlinable
    package mutating func siftDown(over count: Int) {
        var parent = 0
        while true {
            let left = 2 * parent + 1
            let right = left + 1
            var minimum = parent

            if left < count, column[slot(left)] < column[slot(minimum)] {
                minimum = left
            }
            if right < count, column[slot(right)] < column[slot(minimum)] {
                minimum = right
            }
            if minimum == parent {
                return
            }

            exchange(slot(parent), slot(minimum))
            parent = minimum
        }
    }

    @inlinable
    public mutating func push(_ element: consuming S.Element) {
        let previousCount = count
        precondition(previousCount < column.capacity, "Heap storage capacity exceeded")

        column.unshare()
        column.initialize(at: Index(previousCount), to: element)
        let nextCount = previousCount + .one
        column.initialization = .linear(count: nextCount)
        siftUp(from: Int(clamping: previousCount.rawValue))
    }

    @inlinable
    public mutating func pop() -> S.Element? {
        let previousCount = count
        let elementCount = Int(clamping: previousCount.rawValue)
        guard elementCount > 0 else {
            return nil
        }

        column.unshare()
        let last = slot(elementCount - 1)
        if elementCount == 1 {
            let minimum = column.move(at: last)
            column.initialization = .empty
            return minimum
        }

        column.swapAt(slot(0), last)
        let minimum = column.move(at: last)
        column.initialization = .linear(
            count: previousCount.subtracting(saturating: .one)
        )
        siftDown(over: elementCount - 1)
        return minimum
    }
}
