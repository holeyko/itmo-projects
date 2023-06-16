package info.kgeorgiy.ja.riabov.bank;

import info.kgeorgiy.ja.riabov.bank.account.Account;
import info.kgeorgiy.ja.riabov.bank.app.JavaApp;
import info.kgeorgiy.ja.riabov.bank.bank.Bank;
import info.kgeorgiy.ja.riabov.bank.person.Person;
import info.kgeorgiy.ja.riabov.bank.test.BankTest;
import info.kgeorgiy.ja.riabov.bank.util.ProxyUtils;

import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.server.UnicastRemoteObject;

public class BankApplication {
    private static final String TEMPLATE = "BankApplication firstname lastname passportNumber accountId amount";

    public static void main(String[] args) {
        try {
            runRmi();
            Bank bank = runBank();

            if (args.length != 5) {
                System.err.printf("Incorrect count of arguments. Correct run: %s", TEMPLATE);
                return;
            }

            String firstname = args[0];
            String lastname = args[1];
            String passportNumber = args[2];
            String accountId = args[3];
            int amount;
            try {
                amount = Integer.parseInt(args[4]);
            } catch (NumberFormatException e) {
                System.err.println("Amount must be a number");
                return;
            }

            Person person = bank.getRemotePerson(passportNumber);
            if (person == null) {
                person = bank.createPerson(firstname, lastname, passportNumber);
            }

            if (
                    !firstname.equals(person.getFirstname()) ||
                            !lastname.equals(person.getLastname()) ||
                            !passportNumber.equals(person.getPassportNumber())
            ) {
                System.err.println("You can't use not your account!!!");
                return;
            }

            Account account = person.getAccount(accountId);
            if (account == null) {
                person.createAccount(accountId);
            }
            account.setAmount(amount);
            System.out.println(account.getAmount());
        } catch (RemoteException e) {
            System.err.println(e.getMessage());
        }
    }

    private static final int DEFAULT_RMI_PORT = 1099;
    private static final String BANK_URL = "//localhost/bank";
    private static final int BANK_PORT = 8099;
    private static final String CLASSPATH = getClassPath();

    private static void runRmi() throws RemoteException {
        UnicastRemoteObject.unexportObject(LocateRegistry.getRegistry(DEFAULT_RMI_PORT), true);
    }

    private static Bank runBank() {
        var bankApp = new JavaApp(
                "Bank Server",
                CLASSPATH,
                "java", "info.kgeorgiy.ja.riabov.bank.Server", Integer.toString(BANK_PORT)
        );
        bankApp.start();

        while (true) {
            try {
                return ProxyUtils.getProxyWithConsoleLog(
                        (Bank) Naming.lookup(BANK_URL), Bank.class
                );
            } catch (NotBoundException | MalformedURLException | RemoteException ignored) {
                // Ignored exception
            }
        }
    }

    private static String getClassPath() {
        try {
            return Path.of(BankTest.class.getProtectionDomain().getCodeSource().getLocation().toURI()).toString();
        } catch (final URISyntaxException e) {
            throw new AssertionError(e);
        }
    }
}
