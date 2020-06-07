require_relative 'Timer'

class LSDRadix
    extend Timer

    # For some reason, this may occasionally fail. This seems to happen when
    # using random rounded floats. Will look into this to fix

    def self.sort(arr)
        max = arr.max.to_i.digits.length
        min = 0
        arr.each do |ele|
            if ele.class == Float
                min = [min, -ele.to_s.split('.')[1].length].min
            end
        end
        (min...max).each { |i| arr = counting_sort(arr, i) }
        return arr
    end

    def self.counting_sort(input_arr, exp)
        count_arr = Array.new(10){0}
        result = Array.new( input_arr.size )

        n = 10**exp
        m = 10*n

        input_arr.each { |item| count_arr[(item%m)/n] += 1 }
        (1...10).each { |i| count_arr[i] += count_arr[i-1] }

        i = input_arr.size - 1
        while i >= 0
            item = input_arr[i]
            digit = (item%m)/n
            count_arr[digit] -= 1
            result[count_arr[digit]] = item
            i += -1
        end
        return result
    end

end
