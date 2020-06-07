require_relative 'Timer'

class LSDRadix
    extend Timer

    def self.sort(arr)
        exp = arr.max.digits.length
        (0...exp).each { |i| arr = counting_sort(arr, i) }
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
