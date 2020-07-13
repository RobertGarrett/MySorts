require_relative '../Misc/BinarySearch'
require_relative '../Timer'

# Avoids reverse ordered worst case by first comparing each
# element to the first and last elements of sorted
class Insertion
    extend Timer

    def self.sort(arr)
        sorted = [arr[0]]
        (1...arr.length).each do |i|
            if sorted[-1] < arr[i]
                sorted << arr[i]
            else
                idx = arr[i] > sorted[0] ? get_idx(sorted, arr[i]) : 0
                sorted.insert( idx, arr[i] )
            end
        end
        return sorted
    end

    def self.get_idx(arr, val)
        return BinarySearch.insert_idx(arr, val)
    end

end
