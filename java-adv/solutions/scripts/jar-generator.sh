#!/bin/bash

javac -cp ../../java-advanced-2023/artifacts/info.kgeorgiy.java.advanced.implementor.jar \
  ../java-solutions/info/kgeorgiy/ja/riabov/implementor/Implementor.java

cd ../java-solutions || exit

jar cfm ../scripts/Implementor.jar ../scripts/MANIFEST.MF \
  info/kgeorgiy/ja/riabov/implementor/Implementor.class
rm info/kgeorgiy/ja/riabov/implementor/Implementor.class
