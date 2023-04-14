package info.kgeorgiy.ja.riabov.arrayset;

import java.util.*;

public class ArraySet<E> extends AbstractSet<E> implements NavigableSet<E> {
    protected final ReversedList<E> elements;
    protected final Comparator<? super E> comparator;

    private static final Comparator<Object> NATURAL_ORDER = Collections.reverseOrder().reversed();

    public ArraySet() {
        this(new ArrayList<>(), null);
    }

    public ArraySet(final Collection<? extends E> elementsCollection) {
        this(elementsCollection, null);
    }

    public ArraySet(final Collection<? extends E> elementsCollection, final Comparator<? super E> comparator) {
        //        this(toList(elementsCollection, comparator), comparator);
        this.comparator = comparator;
        Set<E> set = new TreeSet<>(comparator);
        set.addAll(elementsCollection);
        this.elements = new ReversedList<>(set, false);
    }


    private static <E> List<? extends E> toList(Collection<? extends E> elementsCollection, Comparator<? super E> comparator) {
        Set<E> set = new TreeSet<>(comparator);
        set.addAll(elementsCollection);
        return set.stream().toList();
    }
    protected ArraySet(ReversedList<E> elements, Comparator<? super E> comparator) {
        this.elements = elements;
        this.comparator = comparator;
    }

    protected int findElementIndex(E element) {
        return Collections.binarySearch(elements, element, comparator);
    }

    protected int findPotentialElementIndex(E element, boolean inclusive, int shift) {
        int result = findElementIndex(element);
        if (result < 0) {
            return shift > 0 ? -result - 2 + shift : -result - 1 + shift;
        }

        return inclusive ? result : result + shift;
    }

    protected E getElementOrNull(int index) {
        return index < 0 || index >= size() ? null : elements.get(index);
    }

    @Override
    public Iterator<E> iterator() {
        return elements.iterator();
    }

    @Override
    public int size() {
        return elements.size();
    }

    @Override
    public Comparator<? super E> comparator() {
        return comparator;
    }

    @SuppressWarnings("unchecked")
    protected Comparator<? super E> comparatorOrNaturalOrdering() {
        return comparator != null ? comparator :
                (l, r) -> ((Comparable<? super E>) l).compareTo(r);
    }

    protected void checkEmptyWithException() {
        if (isEmpty()) {
            throw new NoSuchElementException("Set is empty.");
        }
    }

    @Override
    public E first() {
        checkEmptyWithException();
        return elements.get(0);
    }

    @Override
    public E last() {
        checkEmptyWithException();
        return elements.get(size() - 1);
    }

    @Override
    @SuppressWarnings("unchecked")
    public boolean contains(Object o) {
        return findElementIndex((E) o) >= 0;
    }

    @Override
    public NavigableSet<E> descendingSet() {
        return new ArraySet<>(elements.reverse(), comparatorOrNaturalOrdering().reversed());
    }

    @Override
    public Iterator<E> descendingIterator() {
        return elements.reverse().iterator();
    }

    @Override
    public E lower(E e) {
        return getElementOrNull(findPotentialElementIndex(e, false, -1));
    }

    @Override
    public E floor(E e) {
        return getElementOrNull(findPotentialElementIndex(e, true, -1));
    }

    @Override
    public E ceiling(E e) {
        return getElementOrNull(findPotentialElementIndex(e, true, 0));
    }

    @Override
    public E higher(E e) {
        return getElementOrNull(findPotentialElementIndex(e, false, 1));
    }

    protected NavigableSet<E> subSet(int from, int to) {
        return new ArraySet<>(elements.subList(from, to), comparator);
    }

    @Override
    public NavigableSet<E> subSet(E fromElement, E toElement) {
        return subSet(fromElement, true, toElement, false);
    }

    @Override
    public NavigableSet<E> headSet(E toElement) {
        return headSet(toElement, false);
    }

    @Override
    public NavigableSet<E> tailSet(E fromElement) {
        return tailSet(fromElement, true);
    }

    @Override
    public NavigableSet<E> subSet(E fromElement, boolean fromInclusive, E toElement, boolean toInclusive) {
        if (comparatorOrNaturalOrdering().compare(fromElement, toElement) > 0) {
            throw new IllegalArgumentException("fromElement > toElement [fromElement=%s | toElement=%s]."
                    .formatted(fromElement, toElement));
        }

        return subSet(
                findPotentialElementIndex(fromElement, fromInclusive, fromInclusive ? 0 : 1),
                findPotentialElementIndex(toElement, !toInclusive, toInclusive ? 1 : 0)
        );
    }

    @Override
    public NavigableSet<E> headSet(E toElement, boolean inclusive) {
        return subSet(0, findPotentialElementIndex(toElement, !inclusive, inclusive ? 1 : 0));
    }

    @Override
    public NavigableSet<E> tailSet(E fromElement, boolean inclusive) {
        return subSet(findPotentialElementIndex(fromElement, inclusive, inclusive ? 0 : 1), size());
    }

    @Override
    public E pollFirst() {
        throw new UnsupportedOperationException();
    }

    @Override
    public E pollLast() {
        throw new UnsupportedOperationException();
    }

}