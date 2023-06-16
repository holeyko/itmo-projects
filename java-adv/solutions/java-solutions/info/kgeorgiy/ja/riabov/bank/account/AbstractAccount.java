package info.kgeorgiy.ja.riabov.bank.account;

import java.rmi.RemoteException;

public abstract class AbstractAccount implements Account {
    protected final String id;
    protected long amount;

    public AbstractAccount(final String id) {
        this.id = id;
        this.amount = 0;
    }

    public AbstractAccount(final String id, final long amount) {
            this.id = id;
            this.amount = amount;
    }

    @Override
    public String getId() {
        return id;
    }

    @Override
    public void setAmount(final long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount mustn't be negative [amount=%s]"
                    .formatted(amount));
        }
        setAmountImpl(amount);
    }

    protected abstract void setAmountImpl(final long amount);
}
