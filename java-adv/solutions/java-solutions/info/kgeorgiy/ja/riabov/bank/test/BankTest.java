package info.kgeorgiy.ja.riabov.bank.test;


import info.kgeorgiy.ja.riabov.bank.account.Account;
import info.kgeorgiy.ja.riabov.bank.app.JavaApp;
import info.kgeorgiy.ja.riabov.bank.bank.Bank;
import info.kgeorgiy.ja.riabov.bank.person.Person;
import info.kgeorgiy.ja.riabov.bank.util.ProxyUtils;
import org.junit.jupiter.api.*;

import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.stream.Stream;

public class BankTest {
    private record PersonData(String firstname, String lastname, String passportNumber) {
    }

    private record AccountData(String id, long amount) {
    }

    private interface Task {
        void accept() throws RemoteException;
    }

    private static final String BANK_URL = "//localhost/bank";
    private static final String CLASSPATH = getClassPath();
    private static final int DEFAULT_RMI_PORT = 1099;
    private static int BANK_PORT = 8088;
    private static char DELIMITER = ':';
    private static final List<PersonData> PEOPLE_DATA = List.of(
            new PersonData("Vadim", "Ryabov", "777-888"),
            new PersonData("Mavlytov", "Ervin", "888-9999-12"),
            new PersonData("Hayrullin", "Alex", "666-666"),
            new PersonData("Popov", "Vadim", "99-99-888-1")
    );
    private static final List<AccountData> ACCOUNTS_DATA = List.of(
            new AccountData("asdfhj123adsf", 200),
            new AccountData("13123123", 0),
            new AccountData("192asdf1298", 100),
            new AccountData("aaa", Long.MAX_VALUE),
            new AccountData("bab", 234),
            new AccountData("a", 1000213),
            new AccountData("238923-248kjlh&asdf", 100),
            new AccountData("asdf", 2349)
    );
    private static final List<String> INCORRECT_ACCOUNT_IDS = List.of(
            "184assdfajs:23i4",
            "132adsf:",
            ":a123",
            ":asdfas:asdfas:",
            "a123123-12313-12321:::1213",
            ":"
    );

    private JavaApp bankApp;
    private Bank bank;

    @Test
    public void test01_GetPersonData() throws RemoteException {
        final var people = createPeople(PEOPLE_DATA);
        Task task = () -> {
            for (Map.Entry<PersonData, Person> entry : people.entrySet()) {
                var personData = entry.getKey();
                var person = entry.getValue();

                Assertions.assertEquals(personData.firstname, person.getFirstname());
                Assertions.assertEquals(personData.lastname, person.getLastname());
                Assertions.assertEquals(personData.passportNumber, person.getPassportNumber());
            }
        };

        for (int threads = 1; threads <= 10; ++threads) {
            test_Multithreading(threads, task);
        }
    }

    @Test
    public void test02_FindPersonByPassportNumber() throws RemoteException {
        final var people = createPeople(PEOPLE_DATA);
        Task task = () -> {
            Person remotePerson;
            for (var entry : people.entrySet()) {
                var personData = entry.getKey();
                remotePerson = bank.getRemotePerson(personData.passportNumber);
                Assertions.assertEquals(personData.firstname, remotePerson.getFirstname());
                Assertions.assertEquals(personData.lastname, remotePerson.getLastname());
                Assertions.assertEquals(personData.passportNumber, remotePerson.getPassportNumber());
            }
        };

        for (int threads = 1; threads <= 10; ++threads) {
            test_Multithreading(threads, task);
        }
    }

    @Test
    public void test03_severalPersonAccounts() throws RemoteException {
        var personData = PEOPLE_DATA.get(0);
        createPerson(personData);
        Task task = () -> {
            Person person = bank.getRemotePerson(personData.passportNumber);
            Map<AccountData, Account> accounts = new HashMap<>();
            for (var accountData : ACCOUNTS_DATA) {
                Account account = person.createAccount(accountData.id);
                account.setAmount(accountData.amount);
                accounts.put(accountData, account);
            }

            for (var entry : accounts.entrySet()) {
                AccountData accountData = entry.getKey();
                Account account = entry.getValue();
                Account accountFromBank = bank.getAccount(
                        person.getPassportNumber() + DELIMITER + accountData.id
                );

                Assertions.assertEquals(accountData.id, account.getId());
                Assertions.assertEquals(accountData.amount, account.getAmount());
                Assertions.assertNotNull(accountFromBank);
                Assertions.assertEquals(accountData.id, accountFromBank.getId());
                Assertions.assertEquals(accountData.amount, accountFromBank.getAmount());
            }
        };

        for (int threads = 1; threads <= 10; ++threads) {
            test_Multithreading(threads, task);
        }
    }

    @Test
    public void test04_severalAnonymousAccounts() throws RemoteException {
        Task task = () -> {
            Map<AccountData, Account> accounts = new HashMap<>();
            for (var accountData : ACCOUNTS_DATA) {
                bank.createAccount(accountData.id);
                Account account = bank.getAccount(accountData.id);
                account.setAmount(accountData.amount);
                accounts.put(accountData, account);
            }

            for (var entry : accounts.entrySet()) {
                AccountData accountData = entry.getKey();
                Account account = entry.getValue();
                Assertions.assertEquals(accountData.id, account.getId());
                Assertions.assertEquals(accountData.amount, account.getAmount());
            }
        };

        for (int threads = 1; threads <= 10; ++threads) {
            test_Multithreading(threads, task);
        }
    }

    @Test
    public void test05_changeInfoRemotePerson() throws RemoteException {
        var personData = PEOPLE_DATA.get(0);
        createPerson(personData);
        Task task = () -> {
            Person person = bank.getRemotePerson(personData.passportNumber);
            AccountData accountData = ACCOUNTS_DATA.get(0);
            Account createdAccount = person.createAccount(accountData.id);
            createdAccount.setAmount(accountData.amount);

            person = bank.getRemotePerson(personData.passportNumber);
            createdAccount = person.getAccount(accountData.id);

            Assertions.assertNotNull(createdAccount);
            Assertions.assertEquals(accountData.amount, createdAccount.getAmount());
        };

        test(task);
    }

    @Test
    public void test06_changeInfoLocalPerson() throws RemoteException {
        var personData = PEOPLE_DATA.get(0);
        createPerson(personData);
        Task task = () -> {
            Person person = bank.getRemotePerson(personData.passportNumber);
            AccountData accountDataForRemote = ACCOUNTS_DATA.get(0);
            AccountData accountDataForLocal = ACCOUNTS_DATA.get(1);

            person.createAccount(accountDataForRemote.id);
            person = bank.getLocalPerson(personData.passportNumber);
            Account localAccount = person.createAccount(accountDataForLocal.id);
            person.getAccount(accountDataForRemote.id).setAmount(accountDataForLocal.amount);

            person = bank.getRemotePerson(personData.passportNumber);
            Assertions.assertNull(person.getAccount(accountDataForLocal.id));
            Assertions.assertNotEquals(
                    accountDataForRemote.amount,
                    person.getAccount(accountDataForRemote.id).getAmount()
            );
        };

        test(task);
    }

    @Test
    public void test07_incorrectAccountId() throws RemoteException {
        final var people = createPeople(PEOPLE_DATA);
        Task task = () -> {
            PersonData personData = people.keySet().stream().findFirst().orElseThrow();
            Person person = bank.getRemotePerson(personData.passportNumber);

            for (var accountId : INCORRECT_ACCOUNT_IDS) {
                Assertions.assertNull(bank.createAccount(accountId));
                Assertions.assertNull(person.createAccount(accountId));
            }
        };

        for (int threads = 1; threads <= 10; ++threads) {
            test_Multithreading(threads, task);
        }
    }

    public void test(Task task) throws RemoteException {
        test_Multithreading(1, task);
    }

    public void test_Multithreading(int threads, Task task) throws RemoteException {
        try (var threadPool = Executors.newFixedThreadPool(threads)) {
            System.out.printf("Count threads %s%n", threads);

            List<Callable<Void>> tasks = Stream.generate(() -> (Callable<Void>) () -> {
                task.accept();
                return null;
            }).limit(threads).toList();

            try {
                List<Future<Void>> futures = threadPool.invokeAll(tasks);
                for (var future : futures) {
                    future.get();
                }
            } catch (InterruptedException e) {
                System.err.println("Thread was interrupted");
                e.printStackTrace();
            } catch (ExecutionException e) {
                if (e.getCause() instanceof RemoteException remoteException) {
                    throw remoteException;
                } else if (e.getCause() instanceof RuntimeException runtimeException) {
                    throw runtimeException;
                } else {
                    System.err.println("Unexpected exception");
                    e.getCause().printStackTrace();
                }
            }
        }
    }

    private Map<PersonData, Person> createPeople(List<PersonData> peopleData) throws RemoteException {
        Map<PersonData, Person> people = new HashMap<>();
        for (var personData : peopleData) {
            people.put(personData, createPerson(personData));
        }

        return people;
    }

    private Person createPerson(PersonData personData) throws RemoteException {
        return bank.createPerson(
                personData.firstname, personData.lastname, personData.passportNumber
        );
    }

    @BeforeAll
    private static void runRmi() {
        try {
            LocateRegistry.createRegistry(DEFAULT_RMI_PORT);
        } catch (RemoteException e) {
            System.err.println("Can't create rmi");
            e.printStackTrace();
        }
    }

    @AfterAll
    private static void closeRmi() {
        try {
            UnicastRemoteObject.unexportObject(LocateRegistry.getRegistry(DEFAULT_RMI_PORT), true);
        } catch (RemoteException ignored) {
            // Ignored exception
        }
    }

    @BeforeEach
    public void runBankProcess() {
        bankApp = new JavaApp(
                "Bank Server",
                CLASSPATH,
                "java", "info.kgeorgiy.ja.riabov.bank.Server", Integer.toString(BANK_PORT)
        );
        bankApp.start();

        while (true) {
            try {
                bank = ProxyUtils.getProxyWithConsoleLog(
                        (Bank) Naming.lookup(BANK_URL), Bank.class
                );
                break;
            } catch (NotBoundException | MalformedURLException | RemoteException ignored) {
                // Ignored exception
            }
        }
    }

    @AfterEach
    public void closeBankProcess() {
        bankApp.stop();
    }

    private static String getClassPath() {
        try {
            return Path.of(BankTest.class.getProtectionDomain().getCodeSource().getLocation().toURI()).toString();
        } catch (final URISyntaxException e) {
            throw new AssertionError(e);
        }
    }
}
