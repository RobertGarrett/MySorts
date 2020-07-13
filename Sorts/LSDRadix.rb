require_relative '../Timer'
require_relative 'Insertion'
require "byebug"

class LSDRadix
    extend Timer

    def self.sort(arr, opts = {})
        suggested_base = 4*Math.log(arr.max, 2).ceil
        @@base = opts[:base] || [[suggested_base, 10].max, 1024].min

        self.get_range(arr).each { |i| arr = counting_sort(arr, i) }

        # Insertion sort to correct for float rounding errors
        # Should have minimal impact on performance
        return Insertion.sort( sign_counting_sort(arr) )
    end

    def self.get_range(arr)
        min = 0
        arr.each do |ele|
            next if ele.class != Float
            @@base = 10 #yet to implement bases for non-base 10 floats
            min = [min, -( (ele%1).to_s.length - 2)].min
        end

        max = [arr.min.abs, arr.max.abs].max
        max = [Math.log(max, @@base).ceil, 0].max
        return (min...max)
    end

    def self.counting_sort(arr, exp)
        n, m = [ @@base**exp, @@base**(exp+1) ]

        count_arr = Array.new(@@base){0}
        arr.each { |e| count_arr[get_sig(e, n, m)] += 1 }
        (1...@@base).each { |i| count_arr[i] += count_arr[i-1] }

        result = Array.new( arr.size )

        for i in 1..arr.size
            sig = get_sig( arr[-i], n, m )
            count_arr[sig] += -1
            result[count_arr[sig]] = arr[-i]
        end
        return result
    end

    def self.get_sig(ele, n, m)
        return ((ele % m) / n).truncate
    end

    def self.sign_counting_sort(arr)
        count_arr = [ arr.count { |e| e < 0 }, arr.size ]
        result = Array.new( arr.size )

        for i in 1..arr.size
            sig = arr[-i] < 0 ? 0 : 1
            count_arr[sig] += -1
            result[count_arr[sig]] = arr[-i]
        end
        return result
    end

end
