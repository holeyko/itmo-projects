#include "subset.h"

#include "randomized_queue.h"

void subset(unsigned long k, std::istream & in, std::ostream & out)
{
    std::string line;
    randomized_queue<std::string> rand_queue;
    while (std::getline(in, line)) {
        rand_queue.enqueue(line);
    }

    while (!rand_queue.empty() && k) {
        out << rand_queue.dequeue() << std::endl;
        --k;
    }
}
