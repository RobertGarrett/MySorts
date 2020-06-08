require_relative 'Timer'
require_relative 'Insertion'

class LSDRadix
    extend Timer

    # Due to Float rounding errors, there may be some inaccuracies after using
    # the radix sort. To eliminate these, we utilize an insertion sort
    # since it is ~O(n) for nearly sorted arrays.
    def self.sort(arr)
        self.get_range(arr).each do |i|
            arr = counting_sort(arr, i)
        end
        return Insertion.sort(arr)
    end

    def self.get_range(arr)
        min, max = [0, arr.max.to_i.digits.length]
        arr.each do |ele|
            if ele.class == Float
                min = [min, -ele.to_s.split('.')[1].length].min
            end
        end
        return (min...max)
    end

    def self.counting_sort(input_arr, exp)
        count_arr = Array.new(10){0}
        result = Array.new( input_arr.size )

        n = 10**exp
        m = 10*n

        input_arr.each do |item|
            digit = ((item%m)/n).truncate
            debugger if digit < 0 || digit > 9
            count_arr[digit] += 1
        end
        (1...10).each { |i| count_arr[i] += count_arr[i-1] }


        i = input_arr.size - 1
        while i >= 0
            item = input_arr[i]
            digit = ((item%m)/n).truncate
            count_arr[digit] -= 1
            result[count_arr[digit]] = item
            i += -1
        end

        return result
    end

end
