require_relative 'Timer'

class ReferenceMergeSort
    extend Timer

    def self.sort(arr)
        tmp = []
        width, len = 1, arr.length
        while width < len
            (0...len).step(2*width) do |start|
                merge( arr, tmp, start, width )
            end
            arr = tmp
            width *= 2
        end
        return arr
    end

    def self.merge(arr, tmp, a, width)
        b = [a+width, arr.length].min
        c = [b+width, arr.length].min

        i, j = a, b
        (a...c).each do |k|
            if i < b && ( j >= c || arr[i] <= arr[j] )
                tmp[k] = arr[i]
                i += 1
            else
                tmp[k] = arr[j]
                j += 1
            end
        end
    end


end

class MyMergeSort
    extend Timer
    def self.sort(arr)
        tmp = []
        width, len = 1, arr.length
        while width < len
            (0...len).step(2*width) do |a|
                merge( arr, tmp, width )
            end
            arr = tmp
            width *= 2
        end
        return arr
    end

    def self.merge(arr, tmp, width)
        b = [width, arr.length].min
        c = [b+width, arr.length].min
        left, right, tmp = arr[0...b], arr[b...c], tmp[0...c]

        while left.length * right.length > 0
            tmp << (left[0] < right[0] ? left.shift : right.shift)
        end
        return tmp + left + right
    end
end
