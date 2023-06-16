package info.kgeorgiy.ja.riabov.hello;

import java.io.IOException;
import java.net.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.IntStream;

public class HelloUDPClient extends AbstractHelloUDPClient {
    private static final String TEMPLATE_MAIN_CALL = "HelloUDPClient hostName|ip port prefix threads requests";

    public static void main(String[] args) {
        mainImpl(args, new HelloUDPClient(), TEMPLATE_MAIN_CALL);
    }

    public HelloUDPClient() {
    }

    @Override
    public void run(
            final String host,
            final int port,
            final String prefix,
            final int threads,
            final int requests
    ) {
        try (final ExecutorService executorService = Executors.newFixedThreadPool(threads)) {
            final SocketAddress address = new InetSocketAddress(host, port);

            IntStream.rangeClosed(1, threads).forEach(threadNumber -> {
                executorService.submit(() -> {
                    try (final DatagramSocket datagramSocket = new DatagramSocket()) {
                        datagramSocket.setSoTimeout(SEND_TIMEOUT);
                        for (int requestNumber = 1; requestNumber <= requests; ++requestNumber) {
                            final String response = sendAndReceiveData(
                                    datagramSocket,
                                    makeRequest(prefix, threadNumber, requestNumber),
                                    address
                            );

                            System.out.println(response);
                        }
                    } catch (SocketException e) {
                        System.err.printf("Fault while socket worked. %s%n", e.getMessage());
                    }
                });
            });
        }
    }

    private String sendAndReceiveData(
            final DatagramSocket datagramSocket,
            final String request,
            final SocketAddress address
    ) throws SocketException {
        final byte[] sentData = request.getBytes(UDPUtils.STANDART_CHARSET);
        final byte[] receivedData = new byte[datagramSocket.getReceiveBufferSize()];
        final DatagramPacket sendPacket = new DatagramPacket(sentData, sentData.length, address);
        final DatagramPacket receivedPacket = new DatagramPacket(receivedData, receivedData.length);

        while (!datagramSocket.isClosed()) {
            try {
                datagramSocket.send(sendPacket);
                try {
                    datagramSocket.receive(receivedPacket);
                    final String response = UDPUtils.getStringResponse(receivedPacket.getData(), receivedPacket.getLength());

                    if (checkHelloResponse(response, request)) {
                        return response;
                    }
                } catch (IOException e) {
                    System.err.printf("Fault while receive packet. %s%n", e.getMessage());
                }
            } catch (PortUnreachableException e) {
                throw e;
            } catch (IOException e) {
                System.err.printf("Fault while packet sent. %s%n", e.getMessage());
            }
        }

        throw new SocketException();
    }
}
