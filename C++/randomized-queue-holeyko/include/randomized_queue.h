#pragma once

#include <algorithm>
#include <cstddef>
#include <iterator>
#include <random>
#include <type_traits>
#include <vector>

namespace {
struct random_generator
{
    random_generator()
        : m_rand_engine(std::random_device{}())
    {
    }

    size_t get_rand_number(size_t max_num) const
    {
        std::uniform_int_distribution<std::size_t> dist(0, max_num);
        return dist(m_rand_engine);
    }

private:
    mutable std::mt19937 m_rand_engine;
};
} // namespace

template <class T>
class randomized_queue
{
    template <bool is_const>
    class Iterator
    {
        friend class randomized_queue;
        using queue_type = std::conditional_t<is_const, const randomized_queue<T>, randomized_queue<T>>;

        size_t cur_index;
        queue_type * p_queue = nullptr;
        std::vector<size_t> shuffled_index;

        Iterator(queue_type & queue, const size_t cur_index)
            : cur_index(cur_index)
            , p_queue(&queue)
            , shuffled_index(queue.elements.size())
        {
            for (size_t i = 0; i < shuffled_index.size(); ++i) {
                shuffled_index[i] = i;
            }

            size_t len = shuffled_index.size();
            for (size_t i = 0; i < len; ++i) {
                size_t new_index = p_queue->r_generator.get_rand_number(len - 1);
                std::swap(shuffled_index[i], shuffled_index[new_index]);
            }
        }

    public:
        using difference_type = std::ptrdiff_t;
        using iterator_category = std::forward_iterator_tag;
        using value_type = std::conditional_t<is_const, const T, T>;
        using pointer = value_type *;
        using reference = value_type &;

        Iterator() = default;
        Iterator(const Iterator &) = default;

        Iterator & operator=(const Iterator &) = default;

        friend bool operator==(const Iterator & l_iter, const Iterator & r_iter)
        {
            return l_iter.p_queue == r_iter.p_queue && l_iter.cur_index == r_iter.cur_index &&
                    (l_iter.cur_index == l_iter.p_queue->size() ||
                     l_iter.shuffled_index[l_iter.cur_index] == r_iter.shuffled_index[r_iter.cur_index]);
        }

        friend bool operator!=(const Iterator & l_iter, const Iterator & r_iter)
        {
            return !(l_iter == r_iter);
        }

        reference operator*() const
        {
            return p_queue->elements[shuffled_index[cur_index]];
        }

        pointer operator->() const
        {
            return &p_queue->elements[shuffled_index[cur_index]];
        }

        Iterator & operator++()
        {
            ++cur_index;
            return *this;
        }

        Iterator operator++(int)
        {
            auto tmp = *this;
            operator++();
            return tmp;
        }
    };

public:
    using iterator = Iterator<false>;
    using const_iterator = Iterator<true>;

    randomized_queue() = default;

    bool empty() const
    {
        return elements.empty();
    }

    size_t size() const
    {
        return elements.size();
    }

    void enqueue(T element)
    {
        elements.push_back(std::forward<T>(element));
    }

    T const & sample() const
    {
        return elements[r_generator.get_rand_number(elements.size() - 1)];
    }

    T dequeue()
    {
        size_t index = r_generator.get_rand_number(elements.size() - 1);
        std::swap(elements[index], elements.back());
        auto tmp = std::move(elements.back());
        elements.pop_back();
        return tmp;
    }

    iterator begin()
    {
        return {*this, 0};
    }

    iterator end()
    {
        return {*this, elements.size()};
    }
    const_iterator begin() const
    {
        return cbegin();
    }

    const_iterator end() const
    {
        return cend();
    }
    const_iterator cbegin() const
    {
        return {*this, 0};
    }
    const_iterator cend() const
    {
        return {*this, elements.size()};
    }

private:
    std::vector<T> elements{};
    random_generator r_generator;
};
