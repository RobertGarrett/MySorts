require_relative 'Timer'

class QuickSort
    extend Timer

    def self.sort(arr)
        arr = arr.clone
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
        (low...high).each do |j|
            if arr[j] <= pivot
                i += 1
                arr[i], arr[j] = arr[j], arr[i]
            end
        end
        arr[i+1], arr[high] = arr[high], arr[i+1]
        return i+1
    end
end

class MyQuickSort
    extend Timer

    def self.sort(arr)
        arr = arr.clone
        stack = [[0, arr.length-1]]
        print arr.to_s + "\n\n"
        while stack.length > 0
            l, h = *stack.pop
            p = partition(arr, l, h)
            print "low: #{l}, high: #{h}, avg: #{arr[(h+l)/2]}\n"
            print arr.to_s + "\n\n"
            stack << [l, p-1] if p-1 > l
            stack << [p+1, h] if p+1 < h
        end
        return arr
    end

    def self.partition(arr, low, high)
        pivot = arr[(high+low)/2]
        i = low - 1
        (low...high).each do |j|
            if arr[j] <= pivot
                i += 1
                arr[i], arr[j] = arr[j], arr[i]
            end
        end
        arr[i+1], arr[(high+low)/2] = arr[(high+low)/2], arr[i+1]
        return i+1
    end
end
