package info.kgeorgiy.ja.riabov.bank.person;

import info.kgeorgiy.ja.riabov.bank.account.Account;
import info.kgeorgiy.ja.riabov.bank.account.LocalAccount;
import info.kgeorgiy.ja.riabov.bank.account.RemoteAccount;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

public class RemotePerson extends AbstractPerson {
    private final ConcurrentHashMap<String, RemoteAccount> accounts;
    private final int port;

    public RemotePerson(
            final String firstname,
            final String lastname,
            final String passportNumber,
            final int port
    ) {
        super(firstname, lastname, passportNumber);
        this.accounts = new ConcurrentHashMap<>();
        this.port = port;
    }

    @Override
    public List<Account> getAccounts() {
        return new ArrayList<>(accounts.values());
    }

    @Override
    public Account createAccountImpl(final String subId) throws RemoteException {
        RemoteAccount account = new RemoteAccount(subId);
        if (accounts.putIfAbsent(subId, account) == null) {
            UnicastRemoteObject.exportObject(account, port);
            return account;
        } else {
            return getAccount(subId);
        }
    }

    @Override
    public Account getAccount(final String subId) {
        return accounts.getOrDefault(subId, null);
    }

    public LocalPerson toLocal() throws RemoteException {
        Map<String, LocalAccount> accountForLocalPerson = new HashMap<>();
        for (var entry : accounts.entrySet()) {
            var subId = entry.getKey();
            var account = entry.getValue();
            accountForLocalPerson.put(subId, new LocalAccount(
                    account.getId(),
                    account.getAmount()
            ));
        }

        return new LocalPerson(firstname, lastname, passportNumber, accountForLocalPerson);
    }
}
