require_relative "../Timer"

class InPlaceInsertion
    extend Timer

    def self.sort(arr)
        (1...arr.length).each do |i|
            next if arr[i-1] < arr[i]
            idx = arr[i] > arr[0] ? get_idx(arr, i) : 0
            arr.insert( idx, arr.delete_at(i) )
        end
        return arr
    end

# Performance also suffered slightly from language implementation of arr[a..b]
# so I created a use specific binary search method which avoids it.

    def self.get_idx(arr, sort_end)
        l, r, x = 0, sort_end, arr[sort_end]
        while l <= r
            m = (r + l) / 2;

            if arr[m] == x
                return m
            elsif arr[m] < x
                l = m + 1
            else
                r = m - 1
            end
        end
        return l
    end
end
