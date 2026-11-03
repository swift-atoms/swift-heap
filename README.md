# swift-heap

Use this package when elements, including `~Copyable` ones, must leave smallest first, whatever order they arrived in: a priority queue ordered by the element's own `<`. Start from `Heap<E>`, which grows on demand in a heap-allocated contiguous column. `Heap<E>` is a `__Heap<S>` over `Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear`. When elements must leave in arrival order instead, use the sibling swift-queue.

## Laws

- Min-first: each `pop()` returns an element no greater than any element still in the heap. Draining a heap yields its elements in ascending order, duplicates included.
- Equal elements leave in no specified order: the heap is not stable, so insertion order does not break ties.
- `min` reads the root without removing it. `push` and `pop` take O(log n) comparisons; `min`, `count` and `isEmpty` take O(1).
- `pop()` returns `nil` exactly when the heap is empty, and leaves the heap unchanged.
- Growth past `minimumCapacity` reallocates and keeps the min-first order.
- `take()` hands back the column in implicit binary-heap layout, not in sorted order: the children of slot `k` sit at `2k + 1` and `2k + 2` and neither is smaller than slot `k`.
