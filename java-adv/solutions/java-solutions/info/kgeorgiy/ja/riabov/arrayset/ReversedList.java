package info.kgeorgiy.ja.riabov.arrayset;

import java.util.*;
import java.util.function.UnaryOperator;

public class ReversedList<E> extends AbstractList<E> implements RandomAccess {
    private final List<E> elements;
    private final boolean reversed;

    public ReversedList() {
        this(false);
    }

    public ReversedList(boolean reversed) {
        this(new ArrayList<>(), reversed);
    }

    public ReversedList(Collection<? extends E> collection, boolean reversed) {
        this(new ArrayList<>(collection), reversed);
    }

    private ReversedList(List<E> elements, boolean reversed) {
        this.elements = Collections.unmodifiableList(elements);
        this.reversed = reversed;
    }

    public ReversedList<E> reverse() {
        return new ReversedList<>(elements, !reversed);
    }

    public boolean isReversed() {
        return reversed;
    }

    @Override
    public E get(int index) {
        return elements.get(reversed ? size() - 1 - index : index);
    }

    @Override
    public int size() {
        return elements.size();
    }

    @Override
    public ReversedList<E> subList(int fromIndex, int toIndex) {
        return new ReversedList<>(this.elements.subList(fromIndex, toIndex), reversed);
    }

    @Override
    public boolean add(E e) {
        return elements.add(e);
    }

    @Override
    public E set(int index, E element) {
        return elements.set(index, element);
    }

    @Override
    public void add(int index, E element) {
        elements.add(index, element);
    }

    @Override
    public E remove(int index) {
        return elements.remove(index);
    }

    @Override
    public void clear() {
        elements.clear();
    }

    @Override
    public boolean addAll(int index, Collection<? extends E> c) {
        return elements.addAll(index, c);
    }

    @Override
    public boolean remove(Object o) {
        return elements.remove(o);
    }

    @Override
    public boolean addAll(Collection<? extends E> c) {
        return elements.addAll(c);
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        return elements.removeAll(c);
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        return elements.retainAll(c);
    }
}
