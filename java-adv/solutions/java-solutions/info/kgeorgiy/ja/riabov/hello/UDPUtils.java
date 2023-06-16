package info.kgeorgiy.ja.riabov.hello;

import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

public class UDPUtils {
    public static final Charset STANDART_CHARSET = StandardCharsets.UTF_8;

    public static String getStringResponse(final byte[] data) {
        return getStringResponse(data, data.length, STANDART_CHARSET);
    }

    public static String getStringResponse(final byte[] data, final int length) {
        return getStringResponse(data, length, STANDART_CHARSET);
    }

    public static String getStringResponse(final byte[] data, final int length, final Charset charset) {
        return new String(data, 0, length, charset);
    }

    public static byte[] readBytesBuffer(final ByteBuffer buf) {
        buf.flip();
        final byte[] dst = new byte[buf.remaining()];
        buf.get(dst);

        return dst;
    }
}
