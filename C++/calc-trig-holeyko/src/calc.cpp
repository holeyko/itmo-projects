#include "calc.h"

#include <cctype>   // for std::isspace
#include <cmath>    // various math functions
#include <iostream> // for error reporting via std::cerr

namespace {

const std::size_t max_decimal_digits = 10;

enum class Op
{
    ERR,
    SET,
    ADD,
    SUB,
    MUL,
    DIV,
    REM,
    NEG,
    POW,
    SQRT,
    SIN,
    COS,
    TAN,
    CTN,
    ASIN,
    ACOS,
    ATAN,
    ACTN,
    RAD,
    DEG
};

std::size_t arity(const Op op)
{
    switch (op) {
    // error
    case Op::ERR: return 0;
    // change settings
    case Op::RAD: return 0;
    case Op::DEG: return 0;
    // unary
    case Op::NEG: return 1;
    case Op::SQRT: return 1;
    case Op::SIN: return 1;
    case Op::COS: return 1;
    case Op::TAN: return 1;
    case Op::CTN: return 1;
    case Op::ASIN: return 1;
    case Op::ACOS: return 1;
    case Op::ATAN: return 1;
    case Op::ACTN: return 1;
    // binary
    case Op::SET: return 2;
    case Op::ADD: return 2;
    case Op::SUB: return 2;
    case Op::MUL: return 2;
    case Op::DIV: return 2;
    case Op::REM: return 2;
    case Op::POW: return 2;
    }
    return 0;
}

Op parse_op(const std::string & line, std::size_t & i)
{
    const auto rollback = [&i, &line](const std::size_t n) {
        i -= n;
        std::cerr << "Unknown operation " << line << std::endl;
        return Op::ERR;
    };
    switch (line[i++]) {
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9':
        --i; // a first digit is a part of op's argument
        return Op::SET;
    case '+':
        return Op::ADD;
    case '-':
        return Op::SUB;
    case '*':
        return Op::MUL;
    case '/':
        return Op::DIV;
    case '%':
        return Op::REM;
    case '_':
        return Op::NEG;
    case '^':
        return Op::POW;
    case 'A':
        switch (line[i++]) {
        case 'C':
            switch (line[i++]) {
            case 'O':
                switch (line[i++]) {
                case 'S':
                    return Op::ACOS;
                default:
                    return rollback(4);
                }
            case 'T':
                switch (line[i++]) {
                case 'N':
                    return Op::ACTN;
                default:
                    return rollback(4);
                }
            default:
                return rollback(3);
            }
        case 'S':
            switch (line[i++]) {
            case 'I':
                switch (line[i++]) {
                case 'N':
                    return Op::ASIN;
                default:
                    return rollback(4);
                }
            default:
                return rollback(3);
            }
        case 'T':
            switch (line[i++]) {
            case 'A':
                switch (line[i++]) {
                case 'N':
                    return Op::ATAN;
                default:
                    return rollback(4);
                }
            default:
                return rollback(3);
            }
        default:
            return rollback(2);
        }
    case 'C':
        switch (line[i++]) {
        case 'O':
            switch (line[i++]) {
            case 'S':
                return Op::COS;
            default:
                return rollback(3);
            }
        case 'T':
            switch (line[i++]) {
            case 'N':
                return Op::CTN;
            default:
                return rollback(3);
            }
        default:
            return rollback(2);
        }
    case 'D':
        switch (line[i++]) {
        case 'E':
            switch (line[i++]) {
            case 'G':
                return Op::DEG;
            default:
                return rollback(3);
            }
        default:
            return rollback(2);
        }
    case 'S':
        switch (line[i++]) {
        case 'Q':
            switch (line[i++]) {
            case 'R':
                switch (line[i++]) {
                case 'T':
                    return Op::SQRT;
                default:
                    return rollback(4);
                }
            default:
                return rollback(3);
            }
        case 'I':
            switch (line[i++]) {
            case 'N':
                return Op::SIN;
            default:
                return rollback(3);
            }
        default:
            return rollback(2);
        }
    case 'R':
        switch (line[i++]) {
        case 'A':
            switch (line[i++]) {
            case 'D':
                return Op::RAD;
            default:
                return rollback(3);
            }
        default:
            return rollback(2);
        }
    case 'T':
        switch (line[i++]) {
        case 'A':
            switch (line[i++]) {
            case 'N':
                return Op::TAN;
            default:
                return rollback(3);
            }
        default:
            return rollback(2);
        }
    default:
        return rollback(1);
    }
}

std::size_t skip_ws(const std::string & line, std::size_t i)
{
    while (i < line.size() && std::isspace(line[i])) {
        ++i;
    }
    return i;
}

double parse_arg(const std::string & line, std::size_t & i)
{
    double res = 0;
    std::size_t count = 0;
    bool good = true;
    bool integer = true;
    double fraction = 1;
    while (good && i < line.size() && count < max_decimal_digits) {
        switch (line[i]) {
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
            if (integer) {
                res *= 10;
                res += line[i] - '0';
            }
            else {
                fraction /= 10;
                res += (line[i] - '0') * fraction;
            }
            ++i;
            ++count;
            break;
        case '.':
            integer = false;
            ++i;
            break;
        default:
            good = false;
            break;
        }
    }
    if (!good) {
        std::cerr << "Argument parsing error at " << i << ": '" << line.substr(i) << "'" << std::endl;
    }
    else if (i < line.size()) {
        std::cerr << "Argument isn't fully parsed, suffix left: '" << line.substr(i) << "'" << std::endl;
    }
    return res;
}

double angle_convert(const double current, bool rad_on, bool from_rad)
{
    if (rad_on) {
        return current;
    }
    return from_rad ? current * (180 / M_PI) : current * (M_PI / 180);
}

double unary(const double current, bool rad_on, const Op op)
{
    double epsilon = 1e-13;
    switch (op) {
    case Op::NEG:
        return -current;
    case Op::SIN:
        return sin(angle_convert(current, rad_on, false));
    case Op::COS:
        return cos(angle_convert(current, rad_on, false));
    case Op::TAN:
        return tan(angle_convert(current, rad_on, false));
    case Op::CTN: {
        if (fabs(angle_convert(current, rad_on, false)) > epsilon)
            return 1 / tan(angle_convert(current, rad_on, false));
        else {
            return HUGE_VAL;
        }
    }
    case Op::ASIN:
        if (current >= -1 && current <= 1) {
            return angle_convert(asin(current), rad_on, true);
        }
        else {
            std::cerr << "Bad argument for ASIN: " << current << std::endl;
            return current;
        }
    case Op::ACOS:
        if (current >= -1 && current <= 1) {
            return angle_convert(acos(current), rad_on, true);
        }
        else {
            std::cerr << "Bad argument for ACOS: " << current << std::endl;
            return current;
        }
    case Op::ATAN:
        return angle_convert(atan(current), rad_on, true);
    case Op::ACTN:
        return angle_convert(M_PI / 2 - atan(current), rad_on, true);
    case Op::SQRT:
        if (current > 0) {
            return sqrt(current);
        }
        else {
            std::cerr << "Bad argument for SQRT: " << current << std::endl;
            [[fallthrough]];
        }
    default:
        return current;
    }
}

double binary(const Op op, const double left, const double right)
{
    switch (op) {
    case Op::SET:
        return right;
    case Op::ADD:
        return left + right;
    case Op::SUB:
        return left - right;
    case Op::MUL:
        return left * right;
    case Op::DIV:
        if (right != 0) {
            return left / right;
        }
        else {
            std::cerr << "Bad right argument for division: " << right << std::endl;
            return left;
        }
    case Op::REM:
        if (right != 0) {
            return std::fmod(left, right);
        }
        else {
            std::cerr << "Bad right argument for remainder: " << right << std::endl;
            return left;
        }
    case Op::POW:
        return std::pow(left, right);
    default:
        return left;
    }
}

} // anonymous namespace

double process_line(const double current, bool & rad_on, const std::string & line)
{
    std::size_t i = 0;
    const auto op = parse_op(line, i);
    switch (arity(op)) {
    case 2: {
        i = skip_ws(line, i);
        const auto old_i = i;
        const auto arg = parse_arg(line, i);
        if (i == old_i) {
            std::cerr << "No argument for a binary operation" << std::endl;
            break;
        }
        else if (i < line.size()) {
            break;
        }
        return binary(op, current, arg);
    }
    case 1: {
        if (i < line.size()) {
            std::cerr << "Unexpected suffix for a unary operation: '" << line.substr(i) << "'" << std::endl;
            break;
        }
        return unary(current, rad_on, op);
    }
    case 0:
        switch (op) {
        case Op::DEG:
        case Op::RAD:
            rad_on = op == Op::RAD;
        default:
            break;
        }
    default: break;
    }
    return current;
}
