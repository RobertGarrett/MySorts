require_relative "Timer"

class InPlaceInsertion
    extend Timer

    def self.sort(arr)
        idx = -1
        (1...arr.length).each do |i|
            next if arr[i-1] < arr[i]
            
            if arr[i] <= arr[0]
                arr.unshift(arr.delete_at(i))
            else
                idx = insert_idx(arr, i, arr[i])
                arr.insert( idx, arr.delete_at(i) )
            end
        end
        return arr
    end

# Performance also suffered slightly from language implementation of arr[a..b]
# so I created a use specific binary search method which avoids it.

    def self.insert_idx(arr, sort_end, x)
        l, r = 0, sort_end
        while l <= r
            m = (r + l) / 2;

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
