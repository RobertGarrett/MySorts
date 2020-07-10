require_relative '../Misc/BinarySearch'
require_relative '../Timer'

# Avoids reverse ordered worst case by first comparing each
# element to the first and last elements of sorted
class Insertion
    extend Timer

    def self.sort(arr)
        sorted = [arr[0]]
        (1...arr.length).each do |i|
            insert(arr, sorted, i)
        end
        return sorted
    end

    def self.insert(arr, sorted, i)
        if sorted[-1] < arr[i]
            sorted << arr[i]
        elsif arr[i] < sorted[0]
            sorted.unshift(arr[i])
        else
            idx = BinarySearch.insert_idx(sorted, arr[i])
            sorted.insert( idx, arr[i] )
        end
    end

end
