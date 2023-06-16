package info.kgeorgiy.ja.riabov.bank.account;

import java.io.Serializable;

public class LocalAccount extends AbstractAccount {
    public LocalAccount(final String id) {
        super(id);
    }

    public LocalAccount(final String id, final long amount) {
        super(id, amount);
    }

    @Override
    protected void setAmountImpl(final long amount) {
        this.amount = amount;
    }

    @Override
    public long getAmount() {
        return amount;
    }
}
