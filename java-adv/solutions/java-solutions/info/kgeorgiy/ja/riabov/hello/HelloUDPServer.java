package info.kgeorgiy.ja.riabov.hello;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;
import java.util.Optional;
import java.util.stream.IntStream;

public class HelloUDPServer extends AbstractHelloUDPServer {
    private static final String TEMPLATE_MAIN_CALL = "HelloUDPServer port threads";

    public static void main(String[] args) {
        mainImpl(args, new HelloUDPServer(), TEMPLATE_MAIN_CALL);
    }

    private DatagramSocket datagramSocket;

    public HelloUDPServer() {
    }

    @Override
    public void start(int port, int threads) {
        initializeFields(port, threads);

        IntStream.range(0, threads).forEach(i -> workers.submit(this::job));
    }

    @Override
    protected void subInitializeFields(int port) {
        try {
            datagramSocket = new DatagramSocket(port);
        } catch (SocketException e) {
            throw new IllegalStateException("Socket creation was failed", e);
        }
    }

    private void job() {
        try {
            byte[] data = new byte[datagramSocket.getReceiveBufferSize()];
            DatagramPacket packet = new DatagramPacket(data, data.length);

            while (!datagramSocket.isClosed()) {
                try {
                    datagramSocket.receive(packet);
                    try {
                        byte[] responseData = makeResponseData(packet.getData(), packet.getLength());
                        datagramSocket.send(new DatagramPacket(
                                responseData, responseData.length, packet.getSocketAddress())
                        );
                    } catch (IOException e) {
                        System.err.printf("Fault while packet sent %s", e.getMessage());
                    }
                } catch (IOException e) {
                    System.err.printf("Fault while packet received %s", e.getMessage());
                }
            }
        } catch (SocketException e) {
            System.err.printf("Fault while socket worked. %s", e.getMessage());
            close();
        }
    }

    @Override
    protected void closeOther() {
        Optional.ofNullable(datagramSocket).ifPresent(DatagramSocket::close);
    }
}
