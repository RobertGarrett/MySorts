require_relative 'Timer'

class QuickSort
    extend Timer

    def self.sort(arr)
        stack = [[0, arr.length-1]]

        while stack.length > 0
            l, h = *stack.pop
            p = partition(arr, l, h)
            stack << [l, p-1] if p-1 > l
            stack << [p+1, h] if p+1 < h
        end
        return arr
    end

    def self.partition(arr, low, high)
        pivot = arr[high]
        i = low - 1
        (low..high).each do |j|
            if arr[j] <= pivot
                i += 1
                arr[i], arr[j] = arr[j], arr[i]
            end
        end
        return i
    end
end

class RandomQuickSort
    extend Timer

    def self.sort(arr)
        stack = [[0, arr.length-1]]
        while stack.length > 0
            l, h = *stack.pop
            p = partition(arr, l, h)
            stack << [l, p-1] if p-1 > l
            stack << [p+1, h] if p+1 < h
        end
        return arr
    end

    def self.partition(arr, l, h)
        r = rand(l..h)
        arr[h], arr[r] = arr[r], arr[h]

        pivot = arr[h]
        i = l - 1
        (l..h).each do |j|
            if arr[j] <= pivot
                i += 1
                arr[i], arr[j] = arr[j], arr[i]
            end
        end
        return i
    end
end

class RubyQuickSort
    extend Timer
    def self.sort(arr)
        return arr.sort
    end
end
