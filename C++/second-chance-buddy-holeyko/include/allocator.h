#pragma once

#include "pool.h"

#include <cstdint>

class AllocatorWithPool : private PoolAllocator
{
public:
    AllocatorWithPool(const std::size_t min_power, const std::size_t max_power)
        : PoolAllocator(min_power, max_power)
    {
    }

    template <class T, class... Args>
    T * create(Args &&... args)
    {
        auto * ptr = allocate(sizeof(T));
        return new (ptr) T(std::forward<Args>(args)...);
    }

    template <class T>
    void destroy(void * ptr)
    {
        static_cast<T *>(ptr)->~T();
        deallocate(ptr);
    }
};
