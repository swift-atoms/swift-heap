public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Memory_Allocator
public import Memory
public import Storage_Contiguous

public typealias Heap<E: ~Copyable> =
    __Heap<Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear>
