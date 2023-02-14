#pragma once

#include <cmath>
#include <cstddef>
#include <iostream>
#include <new>
#include <vector>

struct Tree
{
    const size_t size;
    std::vector<size_t> items;

    Tree(const size_t min_p, const size_t max_p);

    void update(size_t v, size_t cur_size);

    bool is_used(size_t v) const;

    bool is_leaf(const size_t v) const;

    bool is_free(const size_t v, const size_t cur_size) const;
};

class PoolAllocator
{
    const size_t block_min_capacity;
    std::vector<std::byte> storage;
    Tree tree;

    size_t find_free_space(size_t v, size_t vl, size_t vr, const size_t required_size);

    void free_busy_space(size_t v, size_t vl, size_t vr, const std::byte * ptr);

public:
    PoolAllocator(const unsigned min_p, const unsigned max_p);

    void * allocate(const std::size_t n);

    void deallocate(const void * ptr);
};