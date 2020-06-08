require_relative 'BinarySearch'
require_relative 'Timer'

class Insertion
    extend Timer

    def self.sort(arr)
        sorted = [arr[0]]
        (1...arr.length).each do |i|
            if sorted[-1] < arr[i]
                sorted << arr[i]
            elsif arr[i] < sorted[0]
                sorted.unshift(arr[i])
            else
                idx = BinarySearch.insert_idx(sorted, arr[i])
                sorted.insert( idx, arr[i] )
            end
        end
        return sorted
    end
end
