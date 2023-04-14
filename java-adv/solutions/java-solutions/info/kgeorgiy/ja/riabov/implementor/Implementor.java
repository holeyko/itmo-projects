package info.kgeorgiy.ja.riabov.implementor;

import info.kgeorgiy.java.advanced.implementor.ImplerException;
import info.kgeorgiy.java.advanced.implementor.JarImpler;

import javax.tools.JavaCompiler;
import javax.tools.ToolProvider;
import java.io.*;
import java.lang.reflect.Executable;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.function.Predicate;
import java.util.jar.Attributes;
import java.util.jar.JarOutputStream;
import java.util.jar.Manifest;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.zip.ZipEntry;

/**
 * Implementation of {@link JarImpler}.
 */
public class Implementor implements JarImpler {

    /**
     * Implement a given interface in a given path. If the first argument is {@code "-jar"} the implemented class will be in a jar.
     * First argument is optional {@code "-jar"},
     * second argument must be an interface name that will be implemented,
     * third arguments is path where put the implemented class
     *
     * @param args array of arguments
     */
    public static void main(final String[] args) {
        if (args == null) {
            System.err.println("Args is null");
        }
        if (args.length != 2 && args.length != 3) {
            System.err.println("Correct usage: java Implementor [-jar] <className> <path>");
        }

        try {
            String className = args[args.length - 2];
            String pathName = args[args.length - 1];

            Class<?> token = Class.forName(className);
            Path path = Path.of(pathName);
            Implementor implementor = new Implementor();

            if ("-jar".equals(args[0])) {
                implementor.implementJar(token, path);
            } else {
                implementor.implement(token, path);
            }
        } catch (ImplerException e) {
            System.err.println("Class generation failed. " + e.getMessage());
        } catch (ClassNotFoundException e) {
            System.err.println("Class not found. " + e.getMessage());
        } catch (InvalidPathException e) {
            System.err.println("Invalid path. " + e.getMessage());
        }
    }

    /**
     * System line separator.
     */
    private final static String LINE_SEPARATOR = System.lineSeparator();

    /**
     * Symbol of tab.
     */
    private final static String TAB = "\t";

    /**
     * Extension of java files.
     */
    private final static String JAVA_EXTENSION = ".java";

    /**
     * Extension of compiled java class.
     */
    private final static String CLASS_EXTENSION = ".class";

    /**
     * Separator for a path in the jar.
     */
    private final static char JAR_SEPARATOR = '/';

    /**
     * Predicate that tests executable on final modifier.
     */
    private final static Predicate<Executable> TEST_FINAL = exec ->
            Modifier.isFinal(exec.getModifiers());

    /**
     * Predicate that tests executable on static modifier.
     */
    private final static Predicate<Executable> TEST_STATIC = exec ->
            Modifier.isStatic(exec.getModifiers());

    /**
     * Default constructor of {@link Implementor}.
     */
    public Implementor() {
    }

    @Override
    public void implement(final Class<?> token, final Path root) throws ImplerException {
        validateArguments(token, root);
        final Path pathToImplClass = pathToImplClass(token, root, JAVA_EXTENSION);
        createParentDir(pathToImplClass);

        try (final BufferedWriter classWriter = new BufferedWriter(
                new FileWriter(pathToImplClass.toFile(), StandardCharsets.UTF_8))
        ) {
            classWriter.write(escapingUnicodeCharacters(generateClass(token)));
        } catch (IOException e) {
            throw new ImplerException("Can't write class file [token=%s | root=%s]."
                    .formatted(token.getCanonicalName(), root.toString()), e);
        }
    }

    @Override
    public void implementJar(final Class<?> token, final Path jarFile) throws ImplerException {
        try {
            final Path compileDir = Files.createTempDirectory(jarFile.getParent(), "compileDir_");
            compileDir.toFile().deleteOnExit();

            implement(token, compileDir);
            compileClass(token, compileDir);
            createJar(token, compileDir, jarFile);
        } catch (IOException e) {
            throw new ImplerException("Unable to create a build directory.", e);
        }
    }

    /**
     * Compile a java file to a given path.
     *
     * @param token a class token that will be compiled
     * @param root  a path to class that will be compiled
     * @throws ImplerException if couldn't get JavaCompiler or compilation failed
     */
    private static void compileClass(final Class<?> token, final Path root) throws ImplerException {
        final JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        if (compiler == null) {
            throw new ImplerException("Could not find java compiler, include tools.jar to classpath.");
        }

        final String classpath = getClassPath(token);
        final String[] args = {pathToImplClass(token, root, JAVA_EXTENSION).toString(), "-cp", classpath, "-encoding", "UTF-8"};
        if (compiler.run(null, null, null, args) != 0) {
            throw new ImplerException("Compile java files failed.");
        }
    }

    /**
     * Return classpath for class token.
     *
     * @param token a class token,
     * @return a classpath of the token
     * @throws ImplerException if getting classpath failed
     */
    private static String getClassPath(final Class<?> token) throws ImplerException {
        try {
            return Path.of(token.getProtectionDomain().getCodeSource().getLocation().toURI()).toString();
        } catch (final URISyntaxException e) {
            throw new ImplerException("Get classpath failed", e);
        }
    }


    /**
     * Create a jar from a compiled class.
     * Create a jar in a given path from a given class.
     *
     * @param token   a class token, that was compiled
     * @param root    a path to a compiled class
     * @param jarFile a path to a jarFile
     * @throws ImplerException if {@link IOException} throws while writing
     */
    private static void createJar(final Class<?> token, final Path root, final Path jarFile) throws ImplerException {
        Manifest manifest = new Manifest();
        manifest.getMainAttributes().put(Attributes.Name.MANIFEST_VERSION, "1.0");

        try (JarOutputStream jarOutputStream =
                     new JarOutputStream(new FileOutputStream(jarFile.toFile()), manifest)
        ) {
            jarOutputStream.putNextEntry(new ZipEntry(
                    token.getPackageName().replace('.', JAR_SEPARATOR) +
                            JAR_SEPARATOR + implClassName(token) + CLASS_EXTENSION
            ));
            Files.copy(pathToImplClass(token, root, CLASS_EXTENSION), jarOutputStream);
        } catch (IOException e) {
            throw new ImplerException("Writing to jar failed", e);
        }
    }

    /**
     * Validate arguments that will be passed in {@link #implement(Class, Path)}.
     *
     * @param token a class token of interface that will be implemented
     * @param root  a path to the interface
     * @throws ImplerException if arguments not satisfy conditions
     */
    private void validateArguments(final Class<?> token, final Path root) throws ImplerException {
        if (token == null) {
            throw new ImplerException("Token is null.");
        }
        if (root == null) {
            throw new ImplerException("Root is null.");
        }

        if (token.isPrimitive() || token.isArray()) {
            throw new ImplerException("Can't generate code from token, because token is not a class or an interface [token=%s]."
                    .formatted(token.getCanonicalName()));
        }

        int modifier = token.getModifiers();
        if (Modifier.isFinal(modifier)) {
            throw new ImplerException("Can't extends from class, because class is final [token=%s]"
                    .formatted(token.getCanonicalName()));
        }

        if (Modifier.isPrivate(modifier)) {
            throw new ImplerException("Can't extends/implements class/interface, because class/interface is private [token=%s]"
                    .formatted(token.getCanonicalName()));
        }
    }

    /**
     * Create a directory that will store a generated class.
     *
     * @param path a path to directory that will be created
     * @throws ImplerException if {@link IOException} throws while creating directory
     */
    private void createParentDir(final Path path) throws ImplerException {
        try {
            if (path.getParent() != null) {
                Files.createDirectories(path.getParent());
            }
        } catch (IOException e) {
            throw new ImplerException("Can't create directory for class file [path=%s]."
                    .formatted(path.toString()), e);
        }
    }

    /**
     * Returns a path to a class of class token relative to a root.
     *
     * @param token     a class token
     * @param root      a path for relative
     * @param extension an extension of file
     * @return the relative path from root to the class file
     * @throws ImplerException if {@link InvalidPathException} throws while creating {@link Path}
     */
    private static Path pathToImplClass(final Class<?> token, final Path root, final String extension) throws ImplerException {
        try {
            return root.resolve(
                    Path.of(token.getPackageName().replace(".", File.separator))
                            .resolve(implClassName(token) + extension));
        } catch (InvalidPathException e) {
            throw new ImplerException("Invalid path [token=? | root=?].".formatted(token, root));
        }
    }

    /**
     * Return a name of a generated class.
     *
     * @param token a class token of interface that will be implemented
     * @return the name of the generated class
     */
    private static String implClassName(final Class<?> token) {
        return token.getSimpleName() + "Impl";
    }

    /**
     * Generate a class that implements interface of class token.
     *
     * @param token a class token that will be implemented
     * @return the implementation of interface
     */
    private String generateClass(final Class<?> token) {
        return Stream.of(
                generateHeader(token),
                generateClassOpen(token),
                generateMethods(token),
                generateClassClose()
        ).flatMap(s -> s).collect(Collectors.joining(LINE_SEPARATOR));
    }


    /**
     * Generate a header of an implementation of interface of class token.
     *
     * @param token a class token of the interface that will be implemented
     * @return the header of the implementation of interface.
     */
    private Stream<String> generateHeader(final Class<?> token) {
        return Stream.of(token.getPackage().toString() + ";" + LINE_SEPARATOR);
    }

    /**
     * Generate a class signature for implementation of an interface of class token.
     *
     * @param token class token of interface that will be implemented
     * @return the class signature for implementation of interface.
     */
    private Stream<String> generateClassOpen(final Class<?> token) {
        return Stream.of("public class %s implements %s {".formatted(
                implClassName(token),
                token.getCanonicalName()
        ));
    }

    /**
     * Generate end of a generated class.
     *
     * @return {@link Stream<String>} of end of generated class
     */
    private Stream<String> generateClassClose() {
        return Stream.of("}");
    }

    /**
     * Generate all public methods of interface of class token.
     *
     * @param token a class token of interface that will be implemented
     * @return {@link Stream<String>} of all public methods of interface
     */
    private Stream<String> generateMethods(final Class<?> token) {
        return Arrays.stream(token.getMethods())
                .filter(TEST_FINAL.negate().and(TEST_STATIC.negate()))
                .flatMap(this::generateMethod);
    }

    /**
     * Generate blank method implementation.
     *
     * @param method method that will be generated
     * @return {@link Stream<String>} of implementation of method
     */
    private Stream<String> generateMethod(final Method method) {
        return joinLinesWithTabs(
                1,
                "@Override",
                generateExecutableModifierString(method.getModifiers()) + " " +
                        method.getReturnType().getCanonicalName() + " " +
                        method.getName() + "(" + generateExecutableArgumentsString(method) + ") " +
                        generateExecutableThrowableString(method) + " {",
                generateMethodImplString(method),
                "}"
        );
    }

    /**
     * Generate an access modifier for method.
     *
     * @param modifier modifier of method
     * @return {@link String} of access modifier for method
     */
    private String generateExecutableModifierString(final int modifier) {
        if (Modifier.isPublic(modifier)) {
            return "public";
        } else if (Modifier.isProtected(modifier)) {
            return "protected";
        } else if (Modifier.isPrivate(modifier)) {
            return "private";
        } else {
            throw new IllegalArgumentException("Unknown modifier [modifier=%d]".formatted(modifier));
        }
    }

    /**
     * Generate arguments for executable.
     *
     * @param executable method or constructor that is generated
     * @return {@link String} of arguments for executable
     */
    private String generateExecutableArgumentsString(final Executable executable) {
        return Arrays.stream(executable.getParameters())
                .map(param -> param.getType().getCanonicalName() + " " + param.getName())
                .collect(Collectors.joining(", "));
    }

    /**
     * Generate exceptions that are thrown by executable.
     *
     * @param executable method or constructor that is generated
     * @return {@link String} of exceptions that are thrown by executable
     */
    private String generateExecutableThrowableString(final Executable executable) {
        if (executable.getExceptionTypes().length == 0) {
            return "";
        }

        return "throws " +
                Arrays.stream(executable.getExceptionTypes())
                        .map(Class::getCanonicalName)
                        .collect(Collectors.joining(", "));
    }

    /**
     * Generate body of generated method.
     *
     * @param method method that is generated
     * @return {@link String} of body of generated method
     */
    private String generateMethodImplString(final Method method) {
        return TAB + "return " + generateDefaultValue(method.getReturnType()) + ";";
    }

    /**
     * Generate default value for type of class token.
     *
     * @param token class token
     * @return {@link String} of default value for class token
     */
    private String generateDefaultValue(final Class<?> token) {
        if (token.isPrimitive()) {
            if (token == boolean.class) {
                return "true";
            } else if (token == void.class) {
                return "";
            }
            return "0";
        }
        return "null";
    }

    /**
     * Generates {@link String} of joining {@code lines} with {@code tabSize} tabs in begin and separated by line separator.
     *
     * @param tabSize count tabs in begin of line
     * @param lines   lines that will be joined
     * @return {@link String} of joining {@code lines} with {@code tabSize} tabs in begin
     * and separated by line separator
     */
    private Stream<String> joinLinesWithTabs(final int tabSize, final String... lines) {
        final String tabs = TAB.repeat(tabSize);
        return Arrays.stream(lines).collect(
                Collectors.joining(LINE_SEPARATOR + tabs, tabs, "")
        ).lines();
    }

    /**
     * Escape unicode characters in s.
     * @param s parsed string
     * @return string is escaped unicode characters
     */
    private String escapingUnicodeCharacters(String s) {
        StringBuilder result = new StringBuilder();

        s.chars().forEach(el -> {
            char ch = (char) el;

            if (ch > 128) {
                result.append("\\u").append(String.format("%04X", (int) ch));
            } else {
                result.append(ch);
            }
        });

        return result.toString();
    }
}
