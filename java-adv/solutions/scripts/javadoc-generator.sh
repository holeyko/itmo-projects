#!/bin/bash

java_adv=../../java-advanced-2023
src_deps=$java_adv/modules/info.kgeorgiy.java.advanced.implementor/info/kgeorgiy/java/advanced/implementor
libs=$java_adv/lib
my_src=../java-solutions/info/kgeorgiy/ja/riabov/implementor
dir=../javadoc

javadoc -d $dir -private \
  -encoding "UTF-8" \
  -sourcepath $my_src \
  $my_src/Implementor.java $src_deps/Impler.java $src_deps/JarImpler.java $src_deps/ImplerException.java
