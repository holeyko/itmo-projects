package info.kgeorgiy.ja.riabov.student;

import info.kgeorgiy.java.advanced.student.*;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collector;
import java.util.stream.Collectors;

public class StudentDB implements GroupQuery {
    private final static Comparator<? super Student> compareByName = Comparator.comparing(Student::getLastName).reversed()
            .thenComparing(Comparator.comparing(Student::getFirstName).reversed())
            .thenComparing(Student::compareTo);

    @Override
    public List<String> getFirstNames(List<Student> students) {
        return extractField(students, Student::getFirstName);
    }

    @Override
    public List<String> getLastNames(List<Student> students) {
        return extractField(students, Student::getLastName);
    }

    @Override
    public List<GroupName> getGroups(List<Student> students) {
        return extractField(students, Student::getGroup);
    }

    @Override
    public List<String> getFullNames(List<Student> students) {
        return extractField(students, student -> student.getFirstName() + " " + student.getLastName());
    }

    @Override
    public Set<String> getDistinctFirstNames(List<Student> students) {
        return extractField(students, Student::getFirstName, Collectors.toCollection(TreeSet::new));
    }

    @Override
    public String getMaxStudentFirstName(List<Student> students) {
        return students.stream().max(Student::compareTo).map(Student::getFirstName).orElse("");
    }

    private List<Student> sortStudentsBy(Collection<Student> students, Comparator<? super Student> comparator) {
        return students.stream().sorted(comparator).collect(arrayListCollector());
    }

    @Override
    public List<Student> sortStudentsById(Collection<Student> students) {
        return sortStudentsBy(students, Student::compareTo);
    }

    @Override
    public List<Student> sortStudentsByName(Collection<Student> students) {
        return sortStudentsBy(students, compareByName);
    }

    private <T> List<Student> findStudentsBy(Collection<Student> students, Comparator<? super Student> comparator, Function<Student, T> mapper, T value) {
        return students.stream()
                .filter(student -> value.equals(mapper.apply(student)))
                .sorted(comparator).collect(arrayListCollector());
    }

    @Override
    public List<Student> findStudentsByFirstName(Collection<Student> students, String name) {
        return findStudentsBy(students, compareByName, Student::getFirstName, name);
    }

    @Override
    public List<Student> findStudentsByLastName(Collection<Student> students, String name) {
        return findStudentsBy(students, compareByName, Student::getLastName, name);
    }

    @Override
    public List<Student> findStudentsByGroup(Collection<Student> students, GroupName group) {
        return findStudentsBy(students, compareByName, Student::getGroup, group);
    }

    private <T, C> Map<T, C> getMapFromStudent(
            Collection<Student> students, Function<Student, T> mapper,
            Collector<Student, ?, C> collector) {
        return students.stream().collect(Collectors.groupingBy(mapper, collector));
    }

    private Map<GroupName, List<Student>> getGroupsMap(Collection<Student> students) {
        return getMapFromStudent(students, Student::getGroup, arrayListCollector());
    }

    private List<Group> getGroupsWithSort(Collection<Student> students,
                                          Comparator<? super Group> groupComparator, Comparator<? super Student> studentComparator) {
        return getGroupsMap(students).entrySet().stream()
                .map(entry -> new Group(
                        entry.getKey(),
                        sortStudentsBy(entry.getValue(), studentComparator)))
                .sorted(groupComparator)
                .collect(arrayListCollector());
    }

    @Override
    public Map<String, String> findStudentNamesByGroup(Collection<Student> students, GroupName group) {
        return getMapFromStudent(
                findStudentsByGroup(students, group),
                Student::getLastName,
                Collectors.collectingAndThen(
                        Collectors.minBy(Comparator.comparing(Student::getFirstName)),
                        student -> student.map(Student::getFirstName).orElse("")
                )
        );
    }

    @Override
    public List<Group> getGroupsByName(Collection<Student> students) {
        return getGroupsWithSort(students, Comparator.comparing(Group::getName), compareByName);
    }

    @Override
    public List<Group> getGroupsById(Collection<Student> students) {
        return getGroupsWithSort(students, Comparator.comparing(Group::getName), Student::compareTo);
    }

    private GroupName getLargestGroupBy(
            Collection<Student> students, Collector<Student, ?, Long> collector, boolean reversedGroupName) {
        return getMapFromStudent(students, Student::getGroup, collector)
                .entrySet().stream()
                .max(Comparator.comparingLong(Map.Entry<GroupName, Long>::getValue)
                        .thenComparing(reversedGroupName ?
                                Comparator.comparing(Map.Entry<GroupName, Long>::getKey).reversed() :
                                Comparator.comparing(Map.Entry<GroupName, Long>::getKey)))
                .map(Map.Entry::getKey).orElse(null);
    }

    @Override
    public GroupName getLargestGroup(Collection<Student> students) {
        return getLargestGroupBy(students, Collectors.counting(), false);
    }

    @Override
    public GroupName getLargestGroupFirstName(Collection<Student> students) {
        return getLargestGroupBy(
                students,
                Collectors.collectingAndThen(arrayListCollector(), list -> (long) getDistinctFirstNames(list).size()),
                true
        );
    }

    private <T> Collector<T, ?, List<T>> arrayListCollector() {
        return Collectors.toCollection(ArrayList::new);
    }

    private <T> List<T> extractField(
            List<Student> students, Function<Student, T> mapper) {
        return extractField(students, mapper, arrayListCollector());
    }

    private <T, C extends Collection<? extends T>> C extractField(
            List<Student> students, Function<Student, T> mapper, Collector<T, ?, C> collector) {
        return students.stream().map(mapper).collect(collector);
    }
}
