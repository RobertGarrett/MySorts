require_relative "../Timer"
require "byebug"

class Selection
    extend Timer

    def self.sort(arr)
        last = arr.length
        (0...last/2).each do |i|
            min, max = [i, last-i-1]
            (i..last-i-1).each do |idx|
                min = idx if arr[min] > arr[idx]
                max = idx if arr[max] < arr[idx]
            end

            # Since min is swapped first, the index of max will move to min
            # IF the max is at the current index (i)
            max = min if i == max
            arr[min],    arr[i] = arr[i],    arr[min]
            arr[max], arr[-i-1] = arr[-i-1], arr[max]
        end
        return arr
    end
end
