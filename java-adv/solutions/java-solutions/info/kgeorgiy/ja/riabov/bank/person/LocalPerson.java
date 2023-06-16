package info.kgeorgiy.ja.riabov.bank.person;

import info.kgeorgiy.ja.riabov.bank.account.Account;
import info.kgeorgiy.ja.riabov.bank.account.LocalAccount;
import info.kgeorgiy.ja.riabov.bank.account.RemoteAccount;
import info.kgeorgiy.ja.riabov.bank.util.StringUtils;

import java.io.Serializable;
import java.util.*;

public class LocalPerson extends AbstractPerson {
    private final Map<String, LocalAccount> accounts;

    public LocalPerson(
            final String firstname,
            final String lastname,
            final String passportNumber
    ) {
        this(firstname, lastname, passportNumber, new HashMap<>());
    }

    public LocalPerson(
            final String firstname,
            final String lastname,
            final String passportNumber,
            final Map<String, LocalAccount> defaultAccounts
    ) {
        super(firstname, lastname, passportNumber);
        this.accounts = defaultAccounts;
    }

    @Override
    public Account getAccount(String subId) {
        return accounts.getOrDefault(subId, null);
    }

    @Override
    public List<Account> getAccounts() {
        return new ArrayList<>(accounts.values());
    }

    @Override
    public Account createAccountImpl(final String subId) {
        LocalAccount account = new LocalAccount(subId);
        accounts.putIfAbsent(subId, account);
        return getAccount(subId);
    }
}
