package info.kgeorgiy.ja.riabov.bank.account;

public class RemoteAccount extends AbstractAccount {
    public RemoteAccount(final String id) {
        super(id);
    }

    public RemoteAccount(final String id, final long amount) {
        super(id, amount);
    }

    @Override
    public synchronized long getAmount() {
        return amount;
    }

    @Override
    public synchronized void setAmountImpl(final long amount) {
        this.amount = amount;
    }
}
