package info.kgeorgiy.ja.riabov.crawler;

import info.kgeorgiy.java.advanced.crawler.*;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.*;

public class WebCrawler implements Crawler {
    private static final String MAIN_TEMPLATE = "WebCrawler url [depth [downloads [extractors [perHost]]]]";

    public static void main(String[] args) {
        if (args.length == 0 || args.length > 5) {
            System.err.println("Incorrect count of arguments. Correct use: " + MAIN_TEMPLATE);
        }

        String url = args[0];
        int[] params = {1, 1, 1, 1};
        for (int i = 2; i <= 4; ++i) {
            if (args.length >= i) {
                try {
                    params[i - 2] = Integer.parseInt(args[i - 1]);
                } catch (NumberFormatException ignored) {
                    System.err.println("Incorrect type of argument. Correct use: " + MAIN_TEMPLATE);
                }
            }
        }
        int depth = params[0];
        int downloads = params[1];
        int extractors = params[2];
        int perHost = params[3];

        Crawler crawler;
        try {
            crawler = new WebCrawler(
                    new CachingDownloader(1),
                    downloads, extractors, perHost
            );
        } catch (IOException e) {
            System.out.println(e.getMessage());
            return;
        }

        var result = crawler.download(url, depth);
        System.out.println(result.getDownloaded());
        System.out.println(result.getErrors());
        crawler.close();
    }


    private final Downloader downloader;
    private final ExecutorService downloadsThreadPool;
    private final ExecutorService extractorsThreadPool;
    private final int perHost;

    public WebCrawler(Downloader downloader, int downloaders, int extractors, int perHost) {
        validateConstructorArguments(downloaders, extractors, perHost);

        this.downloader = downloader;
        this.downloadsThreadPool = Executors.newFixedThreadPool(downloaders);
        this.extractorsThreadPool = Executors.newFixedThreadPool(extractors);
        this.perHost = perHost;
    }

    private void validateConstructorArguments(int downloaders, int extractors, int perHost) {
        if (downloaders <= 0) {
            throw new IllegalArgumentException("downloaders must be greater than 0 [downloaders=?]"
                    .formatted(downloaders));
        }
        if (extractors <= 0) {
            throw new IllegalArgumentException("extractors must be greater than 0 [extractors=?]"
                    .formatted(extractors));
        }
        if (perHost <= 0) {
            throw new IllegalArgumentException("perHost must be greater than 0 [perHost=?]"
                    .formatted(perHost));
        }
    }

    @Override
    public Result download(String url, int depth) {
        if (depth <= 0) {
            throw new IllegalArgumentException("Depth must be positive [depth]"
                    .formatted(depth));
        }

        Set<String> successfulUrls = ConcurrentHashMap.newKeySet();
        Set<String> handlingUrls = ConcurrentHashMap.newKeySet();
        Map<String, IOException> errors = new ConcurrentHashMap<>();

        handlingUrls.add(url);
        for (int d = 1; d <= depth; ++d) {
            var finalHandlingUrls = handlingUrls;
            Set<String> futureHandlingUrls = new ConcurrentSkipListSet<>();
            Phaser phaser = new Phaser(1);

            int finalD = d;
            finalHandlingUrls.forEach(curUrl -> {
                phaser.register();
                downloadsThreadPool.submit(() -> {
                    try {
                        Document page = downloader.download(curUrl);
                        successfulUrls.add(curUrl);
                        phaser.register();
                        extractorsThreadPool.submit(() -> {
                            try {
                                if (finalD != depth) {
                                    page.extractLinks().forEach(link -> {
                                        if (!successfulUrls.contains(link) && !errors.containsKey(link) && !finalHandlingUrls.contains(link)) {
                                            futureHandlingUrls.add(link);
                                        }
                                    });
                                }
                            } catch (IOException ignored) {
                                // Ignored exeption
                            } finally {
                                phaser.arrive();
                            }
                        });
                    } catch (IOException e) {
                        errors.put(curUrl, e);
                    } finally {
                        phaser.arrive();
                    }
                });
            });

            phaser.arriveAndAwaitAdvance();
            handlingUrls = futureHandlingUrls;
        }

        return new Result(new ArrayList<>(successfulUrls), errors);
    }

    @Override
    public void close() {
        downloadsThreadPool.close();
        extractorsThreadPool.close();
    }
}
