# CMake generated Testfile for 
# Source directory: /home/holeyko/Main/C++/calc-trig-holeyko
# Build directory: /home/holeyko/Main/C++/calc-trig-holeyko/cmake-build-ubuntu
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(tests "/home/holeyko/Main/C++/calc-trig-holeyko/cmake-build-ubuntu/test/runUnitTests")
set_tests_properties(tests PROPERTIES  _BACKTRACE_TRIPLES "/home/holeyko/Main/C++/calc-trig-holeyko/CMakeLists.txt;107;add_test;/home/holeyko/Main/C++/calc-trig-holeyko/CMakeLists.txt;0;")
subdirs("googletest")
subdirs("test")
