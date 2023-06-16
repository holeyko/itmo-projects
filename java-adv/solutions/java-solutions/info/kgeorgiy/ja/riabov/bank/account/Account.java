package info.kgeorgiy.ja.riabov.bank.account;

import java.io.Serializable;
import java.rmi.*;

public interface Account extends Remote, Serializable {
    /** Returns account identifier. */
    String getId() throws RemoteException;

    /** Returns amount of money in the account. */
    long getAmount() throws RemoteException;

    /** Sets amount of money in the account. */
    void setAmount(long amount) throws RemoteException;
}
