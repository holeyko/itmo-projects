package info.kgeorgiy.ja.riabov.concurrent;

import info.kgeorgiy.java.advanced.mapper.ParallelMapper;

import java.util.*;
import java.util.function.Function;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class ParallelMapperImpl implements ParallelMapper {
    private final Queue<Runnable> tasks;
    private final int maxCountTasks;
    private final List<Thread> handlerThreads;

    public ParallelMapperImpl(int threads) {
        this(threads, 4096);
    }

    public ParallelMapperImpl(int threads, int maxCountTasks) {
        validateArguments(threads, maxCountTasks);

        this.tasks = new ArrayDeque<>();
        this.maxCountTasks = maxCountTasks;
        this.handlerThreads = Stream.generate(() -> {
                    var thread = new Thread(() -> {
                        try {
                            while (!Thread.interrupted()) {
                                getTask().run();
                            }
                        } catch (InterruptedException ignored) {
                            // Ignore exception
                        }
                    });
                    thread.start();
                    return thread;
                })
                .limit(threads)
                .toList();
    }

    private void validateArguments(int threads, int maxCountTasks) {
        if (threads <= 0) {
            throw new IllegalArgumentException("Count of threads must be greater than 0 [threads=%s]"
                    .formatted(threads));
        }
        if (maxCountTasks <= 0) {
            throw new IllegalArgumentException("Count of maxCountTasks must be greater than 0 [maxCountThreads=%s]"
                    .formatted(maxCountTasks));
        }
    }

    private Runnable getTask() throws InterruptedException {
        synchronized (tasks) {
            while (tasks.isEmpty()) {
                tasks.wait();
            }

            tasks.notifyAll();
            return tasks.remove();
        }
    }

    @Override
    public <T, R> List<R> map(Function<? super T, ? extends R> function, List<? extends T> list)
            throws InterruptedException {
        var tasksCounter = new SynchronizedTasksCounter(list.size());
        var results = new ArrayList<R>(Collections.nCopies(list.size(), null));
        var exception = new ArrayList<RuntimeException>(Collections.singleton(null));
        List<Runnable> splitTasks = IntStream.range(0, list.size())
                .mapToObj(i -> (Runnable) () -> {
                    try {
                        results.set(i, function.apply(list.get(i)));
                    } catch (RuntimeException e) {
                        synchronized (exception) {
                            if (exception.get(0) == null) {
                                exception.set(0, e);
                            } else {
                                exception.get(0).addSuppressed(e);
                            }
                        }
                    }

                    tasksCounter.dec();
                })
                .toList();

        addTasks(splitTasks);
        synchronized (tasksCounter) {
            while (tasksCounter.getCounter() != 0) {
                tasksCounter.wait();
            }
        }

        if (exception.get(0) != null) {
            throw exception.get(0);
        }


        return results;
    }

    private void addTasks(List<Runnable> tasksToAdd) throws InterruptedException {
        synchronized (tasks) {
            int lastBoard = 0;
            while (lastBoard < tasksToAdd.size()) {
                while (tasks.size() >= maxCountTasks) {
                    tasks.wait();
                }

                int end = Math.min(tasksToAdd.size(), lastBoard + (maxCountTasks - tasks.size()));
                tasks.addAll(tasksToAdd.subList(lastBoard, end));
                tasks.notifyAll();
                lastBoard = end;
            }
        }
    }

    @Override
    public void close() {
        handlerThreads.forEach(Thread::interrupt);
        handlerThreads.forEach(thread -> {
            while (true) {
                try {
                    thread.join();
                    break;
                } catch (InterruptedException ignored) {
                    // Ignored
                }
            }
        });
    }

    static private class SynchronizedTasksCounter {
        private int counter;

        public SynchronizedTasksCounter(int counter) {
            if (counter <= 0) {
                throw new IllegalArgumentException("Count must be greater than 0 [counter=%s]"
                        .formatted(counter));
            }

            this.counter = counter;
        }

        public synchronized void dec() {
            --counter;
            if (counter == 0) {
                this.notify();
            }
        }

        public synchronized int getCounter() {
            return counter;
        }
    }
}
