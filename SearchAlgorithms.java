
package com.jdbcapp.algorithm;

public class SearchAlgorithms {

    // Linear Search
    public static int linearSearch(int[] ids, int target) {
        for (int i = 0; i < ids.length; i++) {
            if (ids[i] == target) {
                return i;
            }
        }
        return -1;
    }

    // Binary Search: IDs must be sorted
    public static int binarySearch(int[] ids, int target) {
        int left = 0;
        int right = ids.length - 1;

        while (left <= right) {
            int mid = left + (right - left) / 2;

            if (ids[mid] == target) {
                return mid;
            } else if (ids[mid] < target) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }

        return -1;
    }
}
