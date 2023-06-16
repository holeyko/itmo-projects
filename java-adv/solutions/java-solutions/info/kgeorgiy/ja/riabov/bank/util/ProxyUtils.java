package info.kgeorgiy.ja.riabov.bank.util;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Proxy;

public class ProxyUtils {

    public static <T> T getProxyWithConsoleLog(final T obj, final Class<T> clazz) {
        return getProxyWithConsoleLog(obj, clazz, (proxy, method, args) -> {
            System.out.printf("Method %s was called from %s class%n", method.getName(), clazz.getSimpleName());
            return method.invoke(obj, args);
        });
    }

    public static <T> T getProxyWithConsoleLog(
            final T obj,
            final Class<T> clazz,
            final InvocationHandler invocationHandler
    ) {
        return clazz.cast(Proxy.newProxyInstance(
                clazz.getClassLoader(),
                new Class[]{clazz},
                invocationHandler
        ));
    }
}
