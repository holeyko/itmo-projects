package info.kgeorgiy.ja.riabov.bank.person;

import info.kgeorgiy.ja.riabov.bank.account.Account;

import java.io.Serializable;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

public interface Person extends Remote, Serializable {
    String getFirstname() throws RemoteException;

    String getLastname() throws RemoteException;

    String getPassportNumber() throws RemoteException;

    Account getAccount(String subId) throws RemoteException;

    List<Account> getAccounts() throws RemoteException;

    Account createAccount(String subId) throws RemoteException;
}
