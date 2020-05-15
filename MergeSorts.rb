require_relative 'Timer'

class MergeSort
    extend Timer

    def self.sort(arr)
        width, len = 1, arr.length
        while width < len
            (0...len).step(2*width) do |start|
                merge( arr, start, width )
            end
            width *= 2
        end
        return arr
    end

    def self.merge(arr, a, width)
        b = [a+width, arr.length].min
        c = [b+width, arr.length].min

        i, j = a, b
        (a...c).each do |k|
            if i < b && ( j >= c || arr[i] <= arr[j] )
                arr[k] = arr[i]
                i += 1
            else
                arr[k] = arr[j]
                j += 1
            end
        end
    end
end
