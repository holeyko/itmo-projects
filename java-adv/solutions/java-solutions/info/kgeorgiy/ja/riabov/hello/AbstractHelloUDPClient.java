package info.kgeorgiy.ja.riabov.hello;

import info.kgeorgiy.java.advanced.hello.HelloClient;

public abstract class AbstractHelloUDPClient implements HelloClient {
    protected static void mainImpl(String[] args, HelloClient client, String templateCall) {
        if (args.length != 5) {
            System.err.printf("Incorrect run of the program. Correct run: %s%n", templateCall);
            return;
        }

        String host;
        int port;
        String prefix;
        int threads;
        int requests;
        try {
            host = args[0];
            port = Integer.parseInt(args[1]);
            prefix = args[2];
            threads = Integer.parseInt(args[3]);
            requests = Integer.parseInt(args[4]);
        } catch (NumberFormatException e) {
            System.err.printf("Invalid arguments. Correct run: %s. %s%n", templateCall, e.getMessage());
            return;
        }

        try {
            client.run(host, port, prefix, threads, requests);
        } catch (IllegalArgumentException e) {
            System.err.println(e.getMessage());
        }
    }

    protected static final int SEND_TIMEOUT = 30;
    protected static final String REQUEST_TEMPLATE = "%s%d_%d";


    protected boolean checkHelloResponse(final String response, final String request) {
        return response.equals("Hello, " + request);
    }

    protected static String makeRequest(final String prefix, final int threadNumber, final int requestNumber) {
        return REQUEST_TEMPLATE.formatted(
                prefix, threadNumber, requestNumber
        );
    }
}
