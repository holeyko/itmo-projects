#pragma once

#include <iosfwd>
#include <iterator>
#include <memory>
#include <set>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

class Outcast;

class Digraph
{
    using v_connection_type = std::unordered_map<unsigned, std::vector<unsigned>>;

    v_connection_type vertexes_con;

public:
    Digraph() = default;
    Digraph(const v_connection_type & vertexes_con);

    bool contains(unsigned id) const;

    const std::vector<unsigned> & get_connections(unsigned id) const;

    friend std::ostream & operator<<(std::ostream & output, const Digraph & digraph);
};

class ShortestCommonAncestor
{
    const Digraph & graph;

public:
    explicit ShortestCommonAncestor(const Digraph & dg);

    std::pair<unsigned, unsigned> info_between_two_sets(const std::vector<unsigned> &, const std::vector<unsigned> &);

    unsigned length(unsigned v, unsigned w);

    unsigned ancestor(unsigned v, unsigned w);

    unsigned length_subset(const std::set<unsigned> & subset_a, const std::set<unsigned> & subset_b);

    unsigned ancestor_subset(const std::set<unsigned> & subset_a, const std::set<unsigned> & subset_b);
};

class WordNet
{
public:
    WordNet(std::istream & synsets, std::istream & hypernyms);

    class Nouns
    {
        using words_type = std::vector<std::string>;

        const words_type * p_words;

    public:
        class iterator
        {
            friend class Nouns;

            using iter_type = words_type::const_iterator;

            iter_type m_iter;

            iterator(const iter_type & iter)
                : m_iter(iter)
            {
            }

        public:
            using difference_type = std::ptrdiff_t;
            using iterator_category = std::forward_iterator_tag;
            using value_type = std::string;
            using reference = const value_type &;
            using pointer = const value_type *;

            iterator() = default;
            iterator(const iterator &) = default;

            iterator & operator=(const iterator &) = default;

            friend bool operator==(const iterator & left, const iterator & right)
            {
                return left.m_iter == right.m_iter;
            }

            friend bool operator!=(const iterator & left, const iterator & right)
            {
                return !(left == right);
            }

            reference operator*() const
            {
                return *m_iter;
            }

            pointer operator->() const
            {
                return &(*m_iter);
            }

            iterator & operator++()
            {
                ++m_iter;
                return *this;
            }

            iterator operator++(int)
            {
                auto tmp = *this;
                operator++();
                return tmp;
            }
        };

        Nouns(const words_type & words)
            : p_words(&words)
        {
        }

        size_t size() const { return p_words->size(); }

        iterator begin() const { return iterator(p_words->begin()); }
        iterator end() const { return iterator(p_words->end()); }
    };

    // lists all nouns stored in WordNet
    Nouns nouns() const;

    bool is_noun(const std::string & word) const;

    std::string sca(const std::string & noun1, const std::string & noun2) const;

    unsigned distance(const std::string & noun1, const std::string & noun2) const;

private:
    Digraph m_digraph;
    std::unique_ptr<ShortestCommonAncestor> p_sca{};
    std::vector<std::string> words_list;
    std::unordered_map<unsigned, std::string> definitions;
    std::unordered_map<std::string, std::vector<unsigned>> nouns_storage;
};

class Outcast
{
    const WordNet & m_wordnet;

public:
    explicit Outcast(const WordNet & wordnet);

    std::string outcast(const std::set<std::string> & nouns);
};