require_relative "BinarySearch.rb"
require_relative 'Timer'

# Drastically faster compared to QuickSort as implemented in Ruby.
# I suspect this is due to C optimization of insert in the
# core ruby environment, but have not confirmed this.
class InsertionSort
    extend Timer

    def self.sort(arr)
        sorted = [arr[0]]
        (1...arr.length).each do |i|
            sorted.insert(BinarySearch.insert_idx(sorted, arr[i]))
        end
        return sorted
    end
end

# Suffers from language implementation of 'delete_at'
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

# Performance suffers from language implementation of arr[a..b]
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
    InsertionSort.time(arr)
    #InPlaceInsertionSort.time(arr)
end
