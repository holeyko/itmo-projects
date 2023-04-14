package info.kgeorgiy.ja.riabov.concurrent;

import info.kgeorgiy.java.advanced.concurrent.ScalarIP;
import info.kgeorgiy.java.advanced.mapper.ParallelMapper;

import java.util.*;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Stream;

public class IterativeParallelism implements ScalarIP {
    private final ParallelMapper parallelMapper;

    public IterativeParallelism() {
        this(null);
    }

    public IterativeParallelism(ParallelMapper parallelMapper) {
        this.parallelMapper = parallelMapper;
    }

    private <T, R> R multiThreadsListOperation(int threads, List<? extends T> values,
                                               Function<Stream<? extends T>, R> func,
                                               Function<Stream<R>, R> resulter) throws InterruptedException {
        List<List<? extends T>> splitList = splitList(threads, values);

        if (parallelMapper != null) {
            return resulter.apply(parallelMapper.map(
                    list -> func.apply(list.stream()),
                    splitList).stream()
            );
        }

        List<ListHandlerThread<T, R>> handlerThreads = execute(func, splitList);

        return resulter.apply(runHandlerThreads(handlerThreads).stream());
    }

    private static <T, R> List<ListHandlerThread<T, R>> execute(Function<Stream<? extends T>, R> func, List<List<? extends T>> splitList) {
        return splitList.stream()
                .map(subList -> {
                    var thread = new ListHandlerThread<>(subList, func);
                    thread.start();
                    return thread;
                })
                .toList();
    }

    private <T> List<List<? extends T>> splitList(int threads, List<? extends T> values) {
        threads = Math.min(threads, values.size());
        if (threads == 0) {
            throw new IllegalArgumentException("Count threads|values is not positive");
        }

        int step = values.size() / threads;
        int reminder = values.size() % threads;
        int bound = 0;
        List<List<? extends T>> splitList = new ArrayList<>();
        for (int i = 0; i < threads; ++i) {
            int d = reminder > 0 ? 1 : 0;
            splitList.add(values.subList(bound, bound + step + d));
            bound += step + d;
            --reminder;
        }

        return splitList;
    }

    private <T, R> List<R> runHandlerThreads(List<ListHandlerThread<T, R>> handlerThreads) throws InterruptedException {
        var result = new ArrayList<R>();
        InterruptedException joinInterruptedException = null;

        for (int i = 0; i < handlerThreads.size(); ++i) {
            try {
                handlerThreads.get(i).join();
                result.add(handlerThreads.get(i).getResult());
            } catch (InterruptedException e) {
                joinInterruptedException = e;

                for (int j = i; j < handlerThreads.size(); ++j) {
                    try {
                        handlerThreads.get(j).join();
                    } catch (InterruptedException subEx) {
                        e.addSuppressed(subEx);
                        --j;
                    }
                }

                break;
            }
        }

        if (joinInterruptedException != null) {
            throw joinInterruptedException;
        }

        return result;
    }

    @Override
    public <T> T maximum(int threads, List<? extends T> values, Comparator<? super T> comparator) throws
            InterruptedException {
        return multiThreadsListOperation(threads, values,
                stream -> stream.max(comparator).orElse(null),
                stream -> stream.max(comparator).orElse(null)
        );
    }

    @Override
    public <T> T minimum(int threads, List<? extends T> values, Comparator<? super T> comparator) throws
            InterruptedException {
        return maximum(threads, values, comparator.reversed());
    }

    @Override
    public <T> boolean all(int threads, List<? extends T> values, Predicate<? super T> predicate) throws
            InterruptedException {
        return multiThreadsListOperation(
                threads, values,
                stream -> stream.allMatch(predicate),
                stream -> stream.allMatch(Boolean::booleanValue)
        );
    }

    @Override
    public <T> boolean any(int threads, List<? extends T> values, Predicate<? super T> predicate) throws
            InterruptedException {
        return !all(threads, values, predicate.negate());
    }

    @Override
    public <T> int count(int threads, List<? extends T> values, Predicate<? super T> predicate) throws
            InterruptedException {
        return multiThreadsListOperation(
                threads, values,
                stream -> (int) stream.filter(predicate).count(),
                stream -> stream.mapToInt(el -> el).sum()
        );
    }

    private static class ListHandlerThread<T, R> extends Thread {
        private final List<? extends T> values;
        private final Function<Stream<? extends T>, R> func;
        private R result;

        public ListHandlerThread(List<? extends T> values, Function<Stream<? extends T>, R> func) {
            this.values = values;
            this.func = func;
        }

        @Override
        public void run() {
            result = func.apply(values.stream());
        }

        public R getResult() {
            return result;
        }
    }
}
