
package com.jdbcapp.util;

import java.util.ArrayList;
import java.util.List;
import com.jdbcapp.model.Employee;

public class SortAlgorithms {

    // MERGE SORT
    public static List<Employee> mergeSortBySalary(
            List<Employee> employees) {

        List<Employee> result = new ArrayList<>(employees);

        if (result.size() <= 1) {
            return result;
        }

        int mid = result.size() / 2;

        List<Employee> left = mergeSortBySalary(
                result.subList(0, mid));

        List<Employee> right = mergeSortBySalary(
                result.subList(mid, result.size()));

        return merge(left, right);
    }

    private static List<Employee> merge(
            List<Employee> left, List<Employee> right) {

        List<Employee> result = new ArrayList<>();
        int i = 0, j = 0;

        while (i < left.size() && j < right.size()) {
            if (left.get(i).getSalary()
                    <= right.get(j).getSalary()) {
                result.add(left.get(i++));
            } else {
                result.add(right.get(j++));
            }
        }

        while (i < left.size()) result.add(left.get(i++));
        while (j < right.size()) result.add(right.get(j++));

        return result;
    }

    // QUICK SORT
    public static List<Employee> quickSortBySalary(
            List<Employee> employees) {

        List<Employee> result = new ArrayList<>(employees);
        quickSort(result, 0, result.size() - 1);
        return result;
    }

    private static void quickSort(
            List<Employee> list, int low, int high) {

        if (low < high) {
            int pivotIndex = partition(list, low, high);

            quickSort(list, low, pivotIndex - 1);
            quickSort(list, pivotIndex + 1, high);
        }
    }

    private static int partition(
            List<Employee> list, int low, int high) {

        double pivot = list.get(high).getSalary();
        int i = low - 1;

        for (int j = low; j < high; j++) {
            if (list.get(j).getSalary() <= pivot) {
                i++;

                Employee temp = list.get(i);
                list.set(i, list.get(j));
                list.set(j, temp);
            }
        }

        Employee temp = list.get(i + 1);
        list.set(i + 1, list.get(high));
        list.set(high, temp);

        return i + 1;
    }

    // Reverse sorted list for descending order
    public static List<Employee> descending(
            List<Employee> employees) {

        List<Employee> result = new ArrayList<>(employees);
        java.util.Collections.reverse(result);
        return result;
    }
}
