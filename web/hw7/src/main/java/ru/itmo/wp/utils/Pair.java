package ru.itmo.wp.utils;

import java.io.Closeable;
import java.io.IOException;

public class Pair<F, S> implements Closeable {
    private F first;
    private S second;

    public Pair(F first, S second) {
        this.first = first;
        this.second = second;
    }

    public F getFirst() {
        return first;
    }

    public void setFirst(F first) {
        this.first = first;
    }

    public S getSecond() {
        return second;
    }

    @Override
    public String toString() {
        return "Pair{" +
                "first=" + first +
                ", second=" + second +
                '}';
    }

    public void setSecond(S second) {
        this.second = second;
    }

    @Override
    public void close() throws IOException {
        if (first instanceof Cloneable) {
            ((Closeable) first).close();
        }

        if (second instanceof Cloneable) {
            ((Closeable) second).close();
        }
    }
}
