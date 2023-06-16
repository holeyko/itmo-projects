package info.kgeorgiy.ja.riabov.hello;

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

public class HelloUDPNonblockingServer extends AbstractHelloUDPServer {
    private static final String TEMPLATE_MAIN_CALL = "HelloUDPNonblockingServer port threads";

    public static void main(String[] args) {
        mainImpl(args, new HelloUDPNonblockingServer(), TEMPLATE_MAIN_CALL);
    }

    private record HandledResult(SelectionKey selectionKey, SocketAddress address, byte[] data) {
    }

    private static final int MAX_COUNT_WAITING_RESPONSES = 1024;

    private Selector selector;
    private ByteBuffer receiveBuffer;
    private BlockingQueue<HandledResult> handledResults;

    public HelloUDPNonblockingServer() {
    }

    @Override
    public void start(final int port, final int threads) {
        initializeFields(port, threads);

        workers.submit(() -> {
            try {
                while (selector.isOpen()) {
                    if (!handledResults.isEmpty()) {
                        sendResult(handledResults.remove());
                    } else {
                        selector.select(this::handleRequest);
                    }
                }
            } catch (IOException e) {
                System.err.printf("Selector is invalid. %s%n", e.getMessage());
                close();
            }
        });
    }

    @Override
    protected void subInitializeFields(final int port) {
        try {
            selector = Selector.open();
            try {
                final var channel = DatagramChannel.open();
                channel.configureBlocking(false);
                channel.bind(new InetSocketAddress(port));
                channel.register(selector, SelectionKey.OP_READ);

                receiveBuffer = ByteBuffer.allocateDirect(channel.socket().getReceiveBufferSize());
            } catch (IOException e) {
                close();
                throw new IllegalStateException("Datagram channel creation was failed", e);
            }
        } catch (IOException e) {
            close();
            throw new IllegalStateException("Selector creation was failed", e);
        }

        handledResults = new ArrayBlockingQueue<>(MAX_COUNT_WAITING_RESPONSES);
    }

    private void sendResult(final HandledResult handledResult) throws SocketException {
        final DatagramChannel datagramChannel = (DatagramChannel) handledResult.selectionKey.channel();
        try {
            datagramChannel.send(ByteBuffer.wrap(handledResult.data), handledResult.address);
        } catch (IOException e) {
            System.err.printf("Response sending was failed. %s%n", e.getMessage());
        }
    }

    private void handleRequest(final SelectionKey selectionKey) {
        final DatagramChannel datagramChannel = (DatagramChannel) selectionKey.channel();
        try {
            final SocketAddress address = datagramChannel.receive(receiveBuffer.clear());
            final byte[] receivedData = UDPUtils.readBytesBuffer(receiveBuffer);
            workers.submit(() -> {
                try {
                    handledResults.put(new HandledResult(
                            selectionKey, address, makeResponseData(receivedData)
                    ));
                } catch (InterruptedException e) {
                    return;
                }
                selector.wakeup();
            });
        } catch (IOException e) {
            System.err.printf("Request sending was failed. %s%n", e.getMessage());
        }
    }


    @Override
    protected void closeOther() {
        Optional.ofNullable(selector).ifPresent(selector -> {
            selector.keys().forEach(key -> {
                try {
                    key.channel().close();
                } catch (IOException e) {
                    System.err.printf("Channel closing was fault %s%n", e.getMessage());
                }
            });
            try {
                selector.close();
            } catch (IOException e) {
                System.err.printf("Selector closing was fault %s%n", e.getMessage());
            }
        });
    }
}
