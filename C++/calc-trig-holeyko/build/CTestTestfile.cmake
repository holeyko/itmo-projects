# CMake generated Testfile for 
# Source directory: /mnt/d/ITMO/C++/calc-trig-holeyko
# Build directory: /mnt/d/ITMO/C++/calc-trig-holeyko/build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(tests "/mnt/d/ITMO/C++/calc-trig-holeyko/build/test/runUnitTests")
set_tests_properties(tests PROPERTIES  _BACKTRACE_TRIPLES "/mnt/d/ITMO/C++/calc-trig-holeyko/CMakeLists.txt;107;add_test;/mnt/d/ITMO/C++/calc-trig-holeyko/CMakeLists.txt;0;")
subdirs("googletest")
subdirs("test")
