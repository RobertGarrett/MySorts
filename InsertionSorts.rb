require_relative "BinarySearch.rb"
require_relative 'Timer'

# Drastically faster compared to QuickSort as implemented in Ruby.
# I suspect this is due to C optimization of insert in the
# core ruby environment, but have not confirmed this.
# Amazingly enough, this seems to have comparable performance with
# ruby's built in sort method for a randomized data set. This method
# is known to be a quick sort, however it is implemented in C, and is
# thus much faster than a Ruby implementation. An obvious downside
# however, is that this insertion sort has a space complexity of O(n),
# as opposed to quick sorts O(1).

class MyInsertionSort
    extend Timer

    def self.sort(arr)
        sorted = [arr[0]]
        (1...arr.length).each do |i|
            sorted.insert(BinarySearch.insert_idx(sorted, arr[i]))
        end
        return sorted
    end
end

# Attempts to implement an O(1) space complexity insertion sort with
# comparable time complexity to the above method are so far unsuccessful.
# This is seemingly due to the time required to delete an element from
# an array. Will research more into why this is a costly process, and
# attempt to implement a more effective solution.

class InPlaceInsertionSort
    extend Timer

    def self.sort(arr)
        (1...arr.length).each do |i|
            next if arr[i] > arr[i-1]
            idx = arr[i] >= arr[0] ? insert_idx(arr, i, arr[i]) : 0
            arr.insert( idx, arr.delete_at(i) )
        end
        return arr
    end

# Performance also suffered from language implementation of arr[a..b]
# so I created a use specific binary search method which avoids
# this costly process.

    def self.insert_idx(arr, sort_end, x)
        l, r = 0, sort_end
        while l <= r
            m = l + (r - l) / 2;

            if arr[m] == x
                return m
            elsif arr[m] < x
                l = m+1
            else
                r = m - 1
            end
        end
        return l
    end
end

if __FILE__ == $PROGRAM_NAME
    arr = Array.new(1000000){rand(0..100)}
    MyInsertionSort.time(arr)
    #InPlaceInsertionSort.time(arr)
end
