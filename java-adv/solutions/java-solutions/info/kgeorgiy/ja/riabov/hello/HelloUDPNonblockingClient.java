package info.kgeorgiy.ja.riabov.hello;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.DatagramChannel;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.util.*;

public class HelloUDPNonblockingClient extends AbstractHelloUDPClient {
    private static final String TEMPLATE_MAIN_CALL = "HelloUDPClient hostName|ip port prefix threads requests";

    public static void main(final String[] args) {
        mainImpl(args, new HelloUDPNonblockingClient(), TEMPLATE_MAIN_CALL);
    }

    public HelloUDPNonblockingClient() {
    }

    @Override
    public void run(
            final String host,
            final int port,
            final String prefix,
            final int threads,
            final int requests
    ) {
        final SocketAddress address = new InetSocketAddress(host, port);

        try (final Selector selector = Selector.open()) {
            final Map<Integer, RequestContext> unsentRequests = createRequests(prefix, threads, selector);
            int countSelectedKeys = 0;

            while (selector.isOpen() && !unsentRequests.isEmpty()) {
                if (countSelectedKeys == 0) {
                    for (var unsentRequest : unsentRequests.values()) {
                        try {
                            unsentRequest.getChannel().send(
                                    ByteBuffer.wrap(unsentRequest.getRequestText().getBytes(UDPUtils.STANDART_CHARSET)),
                                    address
                            );
                        } catch (IOException e) {
                            System.err.printf("Request sending was failed. %s%n", e.getMessage());
                        }
                    }
                }

                countSelectedKeys = selector.select(selectionKey ->
                        handleSelectionKey(selectionKey, requests, unsentRequests), SEND_TIMEOUT);
            }
        } catch (IOException e) {
            System.err.printf("Selector creation was failed. %s%n", e.getMessage());
        }
    }

    private Map<Integer, RequestContext> createRequests(
            final String prefix,
            final int threads,
            final Selector selector
    ) throws IOException {
        final Map<Integer, RequestContext> requests = new HashMap<>();
        for (int i = 1; i <= threads; ++i) {
            final DatagramChannel channel = DatagramChannel.open();
            final ByteBuffer buffer = ByteBuffer.allocate(channel.socket().getReceiveBufferSize());
            final RequestContext requestContext = new RequestContext(channel, buffer, prefix, i, 1);

            channel.configureBlocking(false);
            channel.register(selector, SelectionKey.OP_READ, requestContext);
            requests.put(i, requestContext);
        }

        return requests;
    }

    private void handleSelectionKey(
            final SelectionKey selectionKey,
            final int requests,
            final Map<Integer, RequestContext> unsentRequests
    ) {
        final RequestContext requestContext = (RequestContext) selectionKey.attachment();
        final String responseText;
        if ((responseText = receiveResponse(requestContext)) != null) {
            System.out.println(responseText);

            if (requestContext.getRequestNumber() >= requests) {
                unsentRequests.remove(requestContext.getThreadNumber());
                try {
                    requestContext.getChannel().close();
                } catch (IOException e) {
                    System.err.printf("Channel closing was failed. %s%n", e.getMessage());
                }
            } else {
                requestContext.incRequestNumber();
            }
        }
    }

    private String receiveResponse(final RequestContext requestContext) {
        final var channel = requestContext.getChannel();
        try {
            final ByteBuffer buffer = requestContext.getBuffer().clear();
            channel.receive(buffer);
            final String responseText = UDPUtils.getStringResponse(UDPUtils.readBytesBuffer(buffer));

            if (checkHelloResponse(responseText, requestContext.getRequestText())) {
                return responseText;
            }
        } catch (IOException e) {
            System.err.printf("Request receiving was failed. %s%n", e.getMessage());
        }

        return null;
    }

    private static class RequestContext {
        private final DatagramChannel channel;
        private final ByteBuffer buffer;
        private final String prefix;
        private final int threadNumber;
        private int requestNumber;
        private String cachedRequestText = null;

        public RequestContext(
                final DatagramChannel channel,
                final ByteBuffer buffer,
                final String prefix,
                final int threadNumber,
                final int requestNumber
        ) {
            this.channel = channel;
            this.buffer = buffer;
            this.prefix = prefix;
            this.threadNumber = threadNumber;
            this.requestNumber = requestNumber;
        }

        public String getRequestText() {
            if (cachedRequestText == null) {
                cachedRequestText = makeRequest(prefix, threadNumber, requestNumber);
            }
            return cachedRequestText;
        }

        public void incRequestNumber() {
            ++requestNumber;
            cachedRequestText = null;
        }

        public String getPrefix() {
            return prefix;
        }

        public int getThreadNumber() {
            return threadNumber;
        }

        public int getRequestNumber() {
            return requestNumber;
        }

        public DatagramChannel getChannel() {
            return channel;
        }

        public ByteBuffer getBuffer() {
            return buffer;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;

            RequestContext that = (RequestContext) o;

            if (threadNumber != that.threadNumber) return false;
            if (requestNumber != that.requestNumber) return false;
            return Objects.equals(prefix, that.prefix);
        }

        @Override
        public int hashCode() {
            int result = prefix != null ? prefix.hashCode() : 0;
            result = 31 * result + threadNumber;
            result = 31 * result + requestNumber;
            return result;
        }
    }
}
