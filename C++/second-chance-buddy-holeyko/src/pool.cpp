#include "pool.h"

Tree::Tree(const size_t min_p, const size_t max_p)
    : size((1 << (max_p - min_p + 1)) - 1)
    , items(size, 0)
{
    const size_t size_floor = 1 << (max_p - min_p);
    for (size_t i = size_floor - 1; i < size; ++i) {
        items[i] = 1 << min_p;
    }
    for (size_t i = size - 1; i > 0; --i) {
        items[(i - 1) / 2] += items[i];
    }
}

void Tree::update(size_t v, size_t cur_size)
{
    while (v != 0) {
        v = (v - 1) / 2;
        cur_size *= 2;
        if (is_free(v, cur_size)) {
            items[v] = cur_size;
        }
        else {
            if (!is_used(v * 2 + 1) && !is_used(v * 2 + 2)) {
                items[v] = items[v * 2 + 1] | items[v * 2 + 2];
            }
            else if (!is_used(v * 2 + 1)) {
                items[v] = items[2 * v + 1];
            }
            else if (!is_used(v * 2 + 2)) {
                items[v] = items[2 * v + 2];
            }
            else {
                items[v] = 0;
            }
        }
    }
}

bool Tree::is_used(size_t v) const
{
    return items[v] == static_cast<size_t>(-1);
}

bool Tree::is_leaf(const size_t v) const
{
    return size / 2 <= v && v < size;
}

bool Tree::is_free(const size_t v, const size_t cur_size) const
{
    return !is_used(v) && (is_leaf(v) || items[v * 2 + 1] + items[v * 2 + 2] == cur_size);
}

PoolAllocator::PoolAllocator(const unsigned int min_p, const unsigned int max_p)
    : block_min_capacity(1 << min_p)
    , storage(1 << max_p)
    , tree(min_p, max_p)
{
}

size_t PoolAllocator::find_free_space(size_t v, size_t vl, size_t vr, size_t required_size)
{
    size_t size_control = (vr - vl) * block_min_capacity;
    if (size_control < required_size || tree.is_used(v)) {
        throw std::bad_alloc{};
    }

    if (size_control == required_size && tree.is_free(v, size_control)) {
        tree.items[v] = static_cast<size_t>(-1);
        tree.update(v, size_control);
        return (vl - tree.size / 2) * block_min_capacity;
    }

    size_t l_value = tree.items[v * 2 + 1];
    size_t r_value = tree.items[v * 2 + 2];
    if (
            !tree.is_used(v * 2 + 1) &&
            (l_value & required_size ||
             (l_value >= required_size && r_value >= required_size && l_value <= r_value) ||
             (l_value >= required_size && r_value < required_size))) {
        return find_free_space(v * 2 + 1, vl, vl + (vr - vl) / 2, required_size);
    }
    else {
        return find_free_space(v * 2 + 2, vl + (vr - vl) / 2, vr, required_size);
    }
}

void PoolAllocator::free_busy_space(size_t v, size_t vl, size_t vr, const std::byte * ptr)
{
    size_t size_control = (vr - vl) * block_min_capacity;
    if (ptr == &storage[(vl - tree.size / 2) * block_min_capacity] && tree.is_used(v)) {
        tree.items[v] = size_control;
        tree.update(v, size_control);
        return;
    }

    size_t mid = (vr - vl) / 2;
    if (ptr < &storage[((vl + mid) - tree.size / 2) * block_min_capacity]) {
        free_busy_space(v * 2 + 1, vl, vl + mid, ptr);
    }
    else {
        free_busy_space(v * 2 + 2, vl + mid, vr, ptr);
    }
}

void * PoolAllocator::allocate(const std::size_t n)
{
    size_t k = ceil(log2(n));
    size_t required_size = std::max(static_cast<size_t>(1 << k), block_min_capacity);
    size_t shift = find_free_space(0, tree.size / 2, tree.size, required_size);
    return &storage[shift];
}

void PoolAllocator::deallocate(const void * ptr)
{
    auto b_ptr = static_cast<const std::byte *>(ptr);
    free_busy_space(0, tree.size / 2, tree.size, b_ptr);
}
