package info.kgeorgiy.ja.riabov.hello;

import info.kgeorgiy.java.advanced.hello.HelloServer;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.net.SocketException;
import java.nio.ByteBuffer;
import java.nio.channels.DatagramChannel;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.util.Optional;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public abstract class AbstractHelloUDPServer implements HelloServer {
    protected static void mainImpl(final String[] args, final HelloServer server, final String templateCall) {
        if (args.length != 2) {
            System.err.printf("Incorrect run of the program. Correct run: %s", templateCall);
            return;
        }

        int port;
        int threads;
        try {
            port = Integer.parseInt(args[0]);
            threads = Integer.parseInt(args[1]);
        } catch (NumberFormatException e) {
            System.err.printf("Invalid arguments. Correct run: %s. %s", templateCall, e.getMessage());
            return;
        }

        try {
            server.start(port, threads);
        } catch (IllegalArgumentException | IllegalStateException e) {
            System.err.println(e.getMessage());
            server.close();
        }
    }

    private static final String RESPONSE_TEMPLATE = "Hello, %s";

    protected ExecutorService workers;

    protected void initializeFields(final int port, final int threads) {
        if (port <= 0) {
            throw new IllegalArgumentException("Port should be positive");
        }
        if (threads <= 0) {
            throw new IllegalArgumentException("Count threads should be positive");
        }

        subInitializeFields(port);
        workers = Executors.newFixedThreadPool(threads + 1);
    }

    protected abstract void subInitializeFields(int port);

    protected byte[] makeResponseData(final byte[] buf) {
        return makeResponseData(buf, buf.length);
    }

    protected byte[] makeResponseData(final byte[] buf, final int length) {
        return RESPONSE_TEMPLATE.formatted(UDPUtils.getStringResponse(buf, length))
                .getBytes(UDPUtils.STANDART_CHARSET);
    }

    @Override
    public void close() {
        closeOther();
        Optional.ofNullable(workers).ifPresent(ExecutorService::close);
    }

    protected abstract void closeOther();
}
