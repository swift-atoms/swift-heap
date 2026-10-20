public import Buffer
public import Buffer_Linear_Primitive
public import Memory
public import Memory_Allocator
public import Storage

public typealias Heap<E: ~Copyable> =
    __Heap<Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear>
