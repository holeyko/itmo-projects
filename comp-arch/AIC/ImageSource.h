#include <fstream>
#include <sstream>

class ImageSource {
protected:
    std::ifstream in;
public:
    ImageSource(std::string path) {
        in.open(path, std::ios::in | std::ios::binary);
    }

    std::string readLine() {
        std::string res;
        getline(in, res);
        return res;
    }

    unsigned char read() {
        return in.get();
    }

    void close() {
        in.close();
    }

    bool isEnd() {
        return in.eof();
    }
};