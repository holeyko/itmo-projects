package info.kgeorgiy.ja.riabov.bank.bank;

import info.kgeorgiy.ja.riabov.bank.account.Account;
import info.kgeorgiy.ja.riabov.bank.account.RemoteAccount;
import info.kgeorgiy.ja.riabov.bank.person.Person;
import info.kgeorgiy.ja.riabov.bank.person.RemotePerson;
import info.kgeorgiy.ja.riabov.bank.util.StringUtils;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

public class RemoteBank implements Bank {
    private static final char DELIMITER = ':';

    private final int port;
    private final ConcurrentMap<String, RemoteAccount> anonymousAccounts = new ConcurrentHashMap<>();
    private final ConcurrentMap<String, RemotePerson> people = new ConcurrentHashMap<>();

    public RemoteBank(final int port) {
        this.port = port;
    }

    @Override
    public Account createAccount(final String id) throws RemoteException {
        RemoteAccount account = null;
        if (StringUtils.countOccurrencesChar(id, DELIMITER) == 0) {
            account = new RemoteAccount(id);
            if (anonymousAccounts.putIfAbsent(id, account) == null) {
                UnicastRemoteObject.exportObject(account, port);
            } else {
                account = (RemoteAccount) getAccount(id);
            }
        }

        return account;
    }

    @Override
    public Account getAccount(final String id) throws RemoteException {
        Person remotePerson = getPersonByAccountId(id);
        Account account;

        if (remotePerson != null) {
            account = remotePerson.getAccount(getAccountSubIdById(id));
        } else {
            account = anonymousAccounts.getOrDefault(id, null);
        }

        return account;
    }

    private Person getPersonByAccountId(final String id) {
        long countDelimiters = StringUtils.countOccurrencesChar(id, DELIMITER);
        Person remotePerson = null;

        if (countDelimiters == 1) {
            int indexDelimiter = id.indexOf(DELIMITER);
            String passportNumber = id.substring(0, indexDelimiter);
            remotePerson = people.getOrDefault(passportNumber, null);
        }

        return remotePerson;
    }

    private String getAccountSubIdById(final String id) {
        return id.substring(0, id.indexOf(DELIMITER));
    }

    @Override
    public Person createPerson(final String firstname, final String lastname, final String passportNumber) throws RemoteException {
        RemotePerson person = new RemotePerson(firstname, lastname, passportNumber, port);
        if (people.putIfAbsent(passportNumber, person) == null) {
            UnicastRemoteObject.exportObject(person, port);
        } else {
            person = (RemotePerson) getRemotePerson(passportNumber);
        }

        return person;
    }

    @Override
    public Person getRemotePerson(String passportNumber) throws RemoteException {
        return people.getOrDefault(passportNumber, null);
    }

    @Override
    public Person getLocalPerson(String passportNumber) throws RemoteException {
        return ((RemotePerson) getRemotePerson(passportNumber)).toLocal();
    }
}
