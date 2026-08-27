public import Heap
public import Storage

public typealias InlineHeap<Element: ~Copyable, let capacity: Int> =
    Heap<Store.Inline<Element, capacity>>
