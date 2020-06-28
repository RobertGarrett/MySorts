require_relative "../Timer"
require "byebug"

class Selection
    extend Timer

    def self.sort(arr)
        last = arr.length
        (0...last/2).each do |i|
            min, max = [i, last-i-1]
            (i..last-i-1).each do |idx|
                debugger unless arr[min] && arr[max] && arr[idx]
                min = idx if arr[min] > arr[idx]
                max = idx if arr[max] < arr[idx]
            end
            max = min if i == max
            arr[min], arr[i] = arr[i], arr[min]
            arr[max], arr[-i-1] = arr[-i-1], arr[max]
        end
        return arr
    end
end
