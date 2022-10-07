#include "wordnet.h"

#include <iostream>
#include <sstream>
int main()
{
    std::istringstream synsets{R"(
82145,zombi zombie living_dead,a dead body that has been brought back to life by a supernatural force
82146,zombi zombie snake_god,a god of voodoo cults of African origin worshipped especially in West Indies
)"};

    std::istringstream hypernyms;

    WordNet wordnet{synsets, hypernyms};
    for (auto it = wordnet.nouns().begin(); it != wordnet.nouns().end(); ++it) {
        auto it1 = it;
        ++it1;
        auto it2 = wordnet.nouns().end();
        if (it1 == it2) {
            std::cout << "asfasfsd f";
        }
        std::cout << "afasfasdfs";
    }
}
