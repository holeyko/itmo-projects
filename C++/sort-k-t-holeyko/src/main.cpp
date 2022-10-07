#include <algorithm>
#include <fstream>
#include <iostream>
#include <optional>
#include <string_view>
#include <vector>

using field_type = std::pair<std::optional<size_t>, std::optional<size_t>>;

struct SeparatorFinder
{
    std::string separator = "---";
    std::vector<std::string> special_separators = {"---", "--"};

    SeparatorFinder() = default;
    SeparatorFinder(const std::string & separator)
        : separator(separator)
    {
    }
    SeparatorFinder(const SeparatorFinder &) = default;

    size_t find_separator(const std::string_view & str) const
    {
        if (separator == "---") {
            auto it = std::find_if(str.begin(), str.end(), [](char ch) { return std::isspace(ch); });
            size_t index = it - str.begin();
            return index == str.size() ? std::string::npos : index;
        }
        else if (separator == "--") {
            auto it = std::find_if(str.begin(), str.end(), [](char ch) { return std::isspace(ch) == 0; });
            size_t index = it - str.begin();
            return index == str.size() ? std::string::npos : index;
        }
        else {
            return str.find(separator);
        }
    }

    size_t sep_size() const
    {
        if (std::find(special_separators.begin(), special_separators.end(), separator) == special_separators.end()) {
            return separator.size();
        }
        return 1;
    }
};

class KTSort
{
    struct LineWithFields
    {
        size_t to;
        size_t from;
        std::string_view view_str;

        LineWithFields(const std::string & str, size_t from, size_t to)
            : to(to)
            , from(from)
            , view_str(str)
        {
        }
        LineWithFields(const LineWithFields &) = default;
        LineWithFields & operator=(const LineWithFields &) = default;

        std::string_view get_fields_substr() const
        {
            return view_str.substr(from, to - from);
        }
    };

public:
    KTSort(const std::string & file_name, const SeparatorFinder & sep_finder, field_type fields)
        : sep_finder(sep_finder)
        , fields(fields)
    {
        if (file_name != "-") {
            from_file = true;
            input.open(file_name);
        }
        handle_input();
    }

    void sort_k_t()
    {
        std::sort(data_storage.begin(), data_storage.end(), compare_lines);
    }

    size_t size() const { return m_size; }

    std::string_view get_elem(size_t index) const
    {
        return data_storage.at(index).view_str;
    }

private:
    bool from_file = false;
    size_t m_size = 0;
    std::ifstream input;
    SeparatorFinder sep_finder;
    field_type fields;
    std::vector<LineWithFields> data_storage;
    std::vector<std::string> string_storage;

    static bool compare_lines(const LineWithFields & first, const LineWithFields & second)
    {
        if (first.to == first.from && second.to == second.from) {
            return first.view_str < second.view_str;
        }
        return first.get_fields_substr() < second.get_fields_substr();
    }

    void handle_input()
    {
        std::string cur_line;
        while ((from_file && getline(input, cur_line)) || (!from_file && getline(std::cin, cur_line))) {
            size_t from = cur_line.size(), to = cur_line.size();
            size_t count = 0, start = 0, pos_sep;
            std::string_view view_line = cur_line;
            while (start <= view_line.size()) {
                pos_sep = sep_finder.find_separator(view_line.substr(start));
                if (pos_sep == std::string::npos) {
                    pos_sep = view_line.size();
                }
                if (pos_sep != 0 || sep_finder.separator == "--") {
                    if (!fields.first) {
                        if (from == view_line.size()) {
                            from = start;
                        }
                    }
                    else if (count == fields.first) {
                        from = start;
                    }
                    else if (fields.second && count == fields.second.value()) {
                        to = pos_sep;
                        break;
                    }
                    ++count;
                }

                start += pos_sep + sep_finder.sep_size();
            }

            ++m_size;
            string_storage.push_back(cur_line);
            data_storage.push_back(LineWithFields(string_storage.back(), from, to));
        }

        if (from_file) {
            input.close();
        }
        else {
            clearerr(stdin);
            std::cin.clear();
        }
    }
};

bool is_number(const std::string & str)
{
    auto it = std::find_if(str.begin(), str.end(), [](char ch) { return std::isdigit(ch) == 0; });
    return it == str.end();
}

void fill_optional_fields(field_type & fields, SeparatorFinder & sep_finder, std::vector<std::string> & files, int argc, char ** args)
{
    int i = 1;
    std::string cur_option;
    SeparatorFinder console_sep_finder("-");
    while (i != argc) {
        cur_option = args[i++];
        if (cur_option == "-k") {
            fields.first = std::stoi(args[i++]) - 1;
            if (i < argc) {
                if (is_number(args[i])) {
                    fields.second = std::stoi(args[i++]) - 1;
                }
            }
        }
        else if (cur_option == "-t") {
            sep_finder.separator = args[i++];
        }
        else if (cur_option.substr(0, 6) == "--key=") {
            const std::string & field_params = cur_option.substr(6);
            size_t comma_pos = field_params.find(',');
            if (comma_pos != std::string::npos) {
                fields.first = std::stoi(field_params.substr(0, comma_pos)) - 1;
                fields.second = std::stoi(field_params.substr(comma_pos + 1)) - 1;
            }
            else {
                fields.first = std::stoi(field_params.data()) - 1;
            }
        }
        else if (cur_option.substr(0, 18) == "--fields-separator=") {
            sep_finder.separator = cur_option.substr(19);
        }
        else {
            auto it_console_sep = std::find_if(cur_option.begin(), cur_option.end(), [](char ch) { return ch != '-'; });
            if (it_console_sep == cur_option.end()) {
                for (size_t pos = 0; pos < cur_option.size(); ++pos) {
                    files.push_back("-");
                }
            }
            else {
                files.push_back(cur_option);
            }
        }
    }
}

int main(int argc, char ** args)
{
    field_type fields;
    SeparatorFinder sep_finder;
    std::vector<std::string> files;
    fill_optional_fields(fields, sep_finder, files, argc, args);

    for (auto file_name : files) {
        KTSort sort_struct{file_name, sep_finder, fields};
        sort_struct.sort_k_t();
        for (size_t i = 0; i < sort_struct.size(); ++i) {
            std::cout << sort_struct.get_elem(i) << std::endl;
        }
    }
}
