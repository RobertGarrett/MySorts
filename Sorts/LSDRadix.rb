require_relative '../Timer'
require_relative 'Insertion'
require "byebug"

class LSDRadix
    extend Timer

    # Due to Float rounding errors, there may be some inaccuracies after using
    # the radix sort. To eliminate these, we utilize an insertion sort
    # since it is ~O(n) for nearly sorted arrays.
    def self.sort(arr)
        positives = arr.reject { |e| e < 0 }
        negatives = arr - positives

        if positives.length > 1
            self.get_range(positives).each do |i|
                positives = counting_sort(positives, i)
            end
        end
        if negatives.length > 1
            self.get_range(negatives).each do |i|
                negatives = counting_sort(negatives, i)
            end
        end
        
        # Note that sense -3 % 10 = 10-3 = 7, the negatives array is already
        # sorted backwards, so there is no need to reverse it.
        return Insertion.sort( negatives + positives )
    end

    def self.get_range(arr)
        min, max = [0, [arr.min.abs, arr.max.abs].max.to_i.to_s.length]
        arr.each do |ele|
            next if ele.class != Float
            min = [min, -ele.to_s.split('.')[1].length].min
        end
        return (min...max)
    end

    def self.counting_sort(input_arr, exp)
        @n = 10**exp
        @m = 10*@n

        count_arr = create_count_arr(input_arr)
        result = Array.new( input_arr.size )

        i = input_arr.size
        while (i += -1) >= 0
            item = input_arr[i]
            sig = ( (item % @m) / @n ).truncate
            count_arr[sig] += -1
            result[count_arr[sig]] = item
        end
        return result
    end

    def self.create_count_arr(arr)
        count_arr = Array.new(10){0}
        arr.each do |item|
            sig = ( (item % @m) / @n ).truncate
            count_arr[sig] += 1
        end
        (1...10).each { |i| count_arr[i] += count_arr[i-1] }
        return count_arr
    end

end
