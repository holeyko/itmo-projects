#include "wordnet.h"

#include <istream>
#include <iterator>
#include <queue>
#include <sstream>

Digraph::Digraph(const v_connection_type & vertexes_con)
    : vertexes_con(vertexes_con)
{
}

bool Digraph::contains(unsigned int id) const
{
    return vertexes_con.find(id) != vertexes_con.end();
}

const std::vector<unsigned> & Digraph::get_connections(unsigned int id) const
{
    return vertexes_con.at(id);
}

std::ostream & operator<<(std::ostream & output, const Digraph & digraph)
{
    for (const auto & [id, vertexes] : digraph.vertexes_con) {
        output << id << ": ";

        for (const unsigned val : vertexes) {
            output << val << " ";
        }
        output << '\n';
    }

    return output;
}

ShortestCommonAncestor::ShortestCommonAncestor(const Digraph & dg)
    : graph(dg)
{
}

std::pair<unsigned, unsigned>
ShortestCommonAncestor::info_between_two_sets(const std::vector<unsigned> & f_set, const std::vector<unsigned> & s_set)
{
    using VertexID = unsigned;
    using Distance = unsigned;
    enum class Color
    {
        First,
        Second
    };

    std::queue<VertexID> queue;
    std::unordered_map<VertexID, std::pair<Distance, Color>> info_bfs;

    for (const VertexID id : f_set) {
        queue.push(id);
        info_bfs[id] = {0, Color::First};
    }
    for (const VertexID id : s_set) {
        if (info_bfs.find(id) != info_bfs.end()) {
            return {id, 0};
        }
        queue.push(id);
        info_bfs[id] = {0, Color::Second};
    }

    std::pair<VertexID, Distance> res = {-1, -1};
    while (!queue.empty()) {
        VertexID id = queue.front();
        const auto [depth, color] = info_bfs[id];
        queue.pop();
        if (!graph.contains(id)) {
            continue;
        }

        for (const VertexID parent_id : graph.get_connections(id)) {
            //            const auto & it_parent = info_bfs.find(parent_id);
            const auto [it_parent, inserted] = info_bfs.try_emplace(parent_id);
            if (inserted) {
                queue.push(parent_id);
                it_parent->second = {depth + 1, color};
                continue;
            }

            auto & ref_parent = it_parent->second;
            if (ref_parent.second != color && res.second > depth + ref_parent.first + 1) {
                res = {parent_id, depth + ref_parent.first + 1};
            }
        }
    }

    return res;
}

unsigned ShortestCommonAncestor::length(unsigned int v, unsigned int w)
{
    return info_between_two_sets({v}, {w}).second;
}

unsigned ShortestCommonAncestor::ancestor(unsigned int v, unsigned int w)
{
    return info_between_two_sets({v}, {w}).first;
}

unsigned ShortestCommonAncestor::length_subset(const std::set<unsigned> & subset_a, const std::set<unsigned> & subset_b)
{
    std::vector<unsigned> subvec_a(subset_a.begin(), subset_a.end());
    std::vector<unsigned> subvec_b(subset_b.begin(), subset_b.end());
    return info_between_two_sets(subvec_a, subvec_b).second;
}

unsigned int
ShortestCommonAncestor::ancestor_subset(const std::set<unsigned> & subset_a, const std::set<unsigned> & subset_b)
{
    std::vector<unsigned> subvec_a(subset_a.begin(), subset_a.end());
    std::vector<unsigned> subvec_b(subset_b.begin(), subset_b.end());
    return info_between_two_sets(subvec_a, subvec_b).first;
}

WordNet::WordNet(std::istream & synsets, std::istream & hypernyms)
{
    std::string str_id, words, def, cur_word;
    while (getline(synsets, str_id, ',')) {
        getline(synsets, words, ',');
        getline(synsets, def);
        unsigned id = std::stoi(str_id);
        std::stringstream ss{words};
        while (ss >> cur_word) {
            if (nouns_storage.find(cur_word) == nouns_storage.end()) {
                words_list.push_back(cur_word);
            }
            nouns_storage[std::move(cur_word)].push_back(id);
        }

        definitions[id] = std::move(def);
    }

    std::unordered_map<unsigned, std::vector<unsigned>> vertex{definitions.size()};
    std::string cur_line, str_cur_id, str_cur_hyper;
    while (getline(hypernyms, cur_line)) {
        if (cur_line.empty()) {
            continue;
        }
        std::stringstream sl{cur_line};
        getline(sl, str_cur_id, ',');
        int cur_id = std::stoi(str_cur_id);
        std::vector<unsigned> connections;
        while (getline(sl, str_cur_hyper, ',')) {
            connections.push_back(std::stoi(str_cur_hyper));
        }
        vertex[cur_id] = std::move(connections);
    }

    m_digraph = Digraph(vertex);
    p_sca = std::make_unique<ShortestCommonAncestor>(ShortestCommonAncestor(m_digraph));
}

WordNet::Nouns WordNet::nouns() const
{
    return Nouns(words_list);
}

bool WordNet::is_noun(const std::string & word) const
{
    auto it = nouns_storage.find(word);
    return it != nouns_storage.end();
}

std::string WordNet::sca(const std::string & noun1, const std::string & noun2) const
{
    return definitions.at(p_sca->info_between_two_sets(nouns_storage.at(noun1), nouns_storage.at(noun2)).first);
}

unsigned int WordNet::distance(const std::string & noun1, const std::string & noun2) const
{
    return p_sca->info_between_two_sets(nouns_storage.at(noun1), nouns_storage.at(noun2)).second;
}

Outcast::Outcast(const WordNet & wordnet)
    : m_wordnet(wordnet)
{
}

std::string Outcast::outcast(const std::set<std::string> & nouns)
{
    std::unordered_map<std::string, unsigned> sum_dist_storage;

    for (auto it_first = nouns.begin(); it_first != nouns.end(); ++it_first) {
        for (auto it_second = std::next(it_first); it_second != nouns.end(); ++it_second) {
            unsigned cur_dist = m_wordnet.distance(*it_first, *it_second);
            sum_dist_storage[*it_first] += cur_dist;
            sum_dist_storage[*it_second] += cur_dist;
        }
    }

    const std::string * max_str = nullptr;
    unsigned max_dist = 0;
    unsigned count_max = 0;
    for (auto it = sum_dist_storage.begin(); it != sum_dist_storage.end(); ++it) {
        if (it->second > max_dist) {
            max_str = &it->first;
            max_dist = it->second;
            count_max = 1;
        }
        else if (it->second == max_dist) {
            ++count_max;
        }
    }

    return count_max == 1 ? *max_str : "";
}