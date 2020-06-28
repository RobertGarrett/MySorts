require_relative "../Timer"
require "byebug"

class Selection
    extend Timer

    def self.sort(arr)
        (0...arr.length).each do |i|
            min = arr[i..-1].each_with_index.inject(i) do |acc, (n, idx)|
                acc = arr[acc] > n ? idx+i : acc
            end
            if min != arr[i]
                arr[min], arr[i] = arr[i], arr[min]
            end
        end
        return arr
    end
end
