require_relative 'Timer'
require "byebug"

class Radix
    extend Timer

    def self.sort(arr)
        exp = arr.max.digits.length
        (0...exp).each { |i| arr = counting_sort(arr, i) }
        return arr
    end

    def self.counting_sort(input_arr, exp = 0)
        count_arr = Array.new(10){0}
        result = Array.new(input_arr.size)

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
        print result
        return result
    end
end

class StringRadix
    extend Timer

    @@ORDER = []

    def self.sort(arr, idx = 0)
        puts "----- #{idx} -----"
        return arr.length > 1 ? counting_sort(arr, idx) : arr
    end

    def self.counting_sort(arr, n)
        print arr
        buckets = Hash.new { |h, k| h[k] = [] }


        arr.each do |item|
            buckets[ item[n] || "nil"] << item
            addChar(item[n])
        end
        @@ORDER << "nil" if

        result = []
        debugger
        @@ORDER.each do |char|
            result += sort(buckets[char], n+1)
        end

        return result
    end

    def self.addChar(char)
        puts "null/space" if !char || char == " "

        if( char && !@@ORDER.include?(char) )
            if @@ORDER.length == 0
                @@ORDER << char
                return
            end

            (0...@@ORDER.length).each do |i|
                if char < @@ORDER[i]
                    @@ORDER.insert(i, char)
                    return
                end
            end
        end
    end

end
