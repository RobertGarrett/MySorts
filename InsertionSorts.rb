require_relative "BinarySearch.rb"
require_relative 'Timer'

class InsertionSort
    extend Timer

    def self.sort(arr)
        sorted = [arr[0]]
        (1...arr.length).each do |i|
            if sorted[-1] < arr[i]
                sorted << arr[i]
            elsif arr[i] < sorted[0]
                sorted.insert(0, arr[i])
            else
                idx = BinarySearch.insert_idx(sorted, arr[i])
                sorted.insert( idx, arr[i] )
            end

            #sorted.insert( bsearch_index{ |x| x == arr[i] } )

        end
        return sorted
    end
end

# This implementation would seemingly be very effective for linked list
# where the computative cost of removing and inserting elements is minimal.
# Will implement in the future.

class InPlaceInsertionSort
    extend Timer

    def self.sort(arr, idx = -1)
        (1...arr.length).each do |i|
            if arr[i-1] < arr[i]
                next
            elsif arr[i] <= arr[0]
                idx = 0
            else
                idx = insert_idx(arr, i, arr[i])
            end
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
    InsertionSort.time_random
    InPlaceInsertionSort.time_random
end
