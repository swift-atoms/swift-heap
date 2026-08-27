# swift-heap

A storage-generic minimum binary heap for move-only and copyable elements.

The core operates over a current `Store.Ledgered.Protocol` column. It owns the heap ordering and logical-count invariant while the caller chooses the storage allocation strategy. Reading the minimum is O(1); insertion and removal are O(log n).

## Installation

Add the package from its canonical atom home:

```swift
dependencies: [
    .package(
        url: "https://github.com/swift-atoms/swift-heap.git",
        branch: "main"
    ),
]
```

Then depend on the core product:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Heap", package: "swift-heap"),
    ]
)
```

## Usage

`Heap` is generic over its storage column. For example, a bounded inline heap uses `Store.Inline`:

```swift
import Heap
import Storage

typealias Queue = Heap<Store.Inline<Int, 64>>

var queue = Queue(column: Store.Inline())
queue.push(42)
queue.push(7)

let minimum = queue.min
let removed = queue.pop()
```

`push` preconditions that the supplied column has available capacity. `pop` returns `nil` when the heap is empty. Elements need only satisfy `Comparison.Protocol` (the atom's `Comparable` ownership seam), so move-only element types are supported.

## Products

The package has exactly three library products:

- `Heap` contains the Foundation-free storage-generic core.
- `Heap Apple Foundation Integration` is the only target that imports Foundation.
- `Heap Test Support` provides `InlineHeap<Element, capacity>`, a concise alias for test fixtures backed by `Store.Inline`.

## Dependencies

All direct dependencies use their canonical atom homes:

- [swift-buffer](https://github.com/swift-atoms/swift-buffer)
- [swift-comparison](https://github.com/swift-atoms/swift-comparison)
- [swift-index](https://github.com/swift-atoms/swift-index)
- [swift-storage](https://github.com/swift-atoms/swift-storage)

The heap algorithm uses Comparison for ordering, Index for typed slots and counts, and Storage for the ledgered column contract. Buffer remains the package's lower-level buffer boundary dependency while concrete storage policy stays outside the heap algorithm.

## Platform posture

The manifest targets Swift 6.4 and the current Apple platform generation. The core contains no Foundation import or platform conditional. Embedded compilation is measured separately because it also depends on the selected toolchain and the Embedded readiness of the dependency closure.

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
