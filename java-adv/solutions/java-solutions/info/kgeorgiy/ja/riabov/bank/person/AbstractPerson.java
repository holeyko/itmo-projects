package info.kgeorgiy.ja.riabov.bank.person;

import info.kgeorgiy.ja.riabov.bank.account.Account;
import info.kgeorgiy.ja.riabov.bank.util.StringUtils;

import java.io.Serializable;
import java.rmi.RemoteException;

public abstract class AbstractPerson implements Person {
    private static final char DELIMITER = ':';

    protected final String firstname;
    protected final String lastname;
    protected final String passportNumber;

    public AbstractPerson(
            final String firstname,
            final String lastname,
            final String passportNumber
    ) {
        this.firstname = firstname;
        this.lastname = lastname;
        this.passportNumber = passportNumber;
    }

    @Override
    public String getFirstname() {
        return firstname;
    }

    @Override
    public String getLastname() {
        return lastname;
    }

    @Override
    public String getPassportNumber() {
        return passportNumber;
    }

    @Override
    public Account createAccount(String subId) throws RemoteException {
        if (StringUtils.countOccurrencesChar(subId, DELIMITER) != 0) {
            return null;
        }
        return createAccountImpl(subId);
    }

    protected abstract Account createAccountImpl(String subId) throws RemoteException;
}
