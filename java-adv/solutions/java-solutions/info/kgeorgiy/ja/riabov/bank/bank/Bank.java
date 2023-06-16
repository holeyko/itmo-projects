package info.kgeorgiy.ja.riabov.bank.bank;

import info.kgeorgiy.ja.riabov.bank.account.Account;
import info.kgeorgiy.ja.riabov.bank.person.Person;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Bank extends Remote {
    /**
     * Creates a new account with specified identifier if it does not already exist.
     *
     * @param id account id
     * @return created or existing account.
     */
    Account createAccount(String id) throws RemoteException;

    /**
     * Returns account by identifier.
     *
     * @param id account id
     * @return account with specified identifier or {@code null} if such account does not exist.
     */
    Account getAccount(String id) throws RemoteException;

    Person getRemotePerson(String passportNumber) throws RemoteException;

    Person getLocalPerson(String passportNumber) throws RemoteException;

    Person createPerson(String firstname, String lastname, String passportNumber) throws RemoteException;
}
