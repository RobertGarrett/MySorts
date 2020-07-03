require_relative "./Config"
require "faker"

class Util
    @@special_vals = Config.CONFIG['special_arrays']
    @@special_vals["nk"].default  = @@special_vals["nk"]["default"]
    @@special_vals["n+k"].default = @@special_vals["n+k"]["default"]


    def self.make_special_arrays(size, t1, t2)
        vals = @@special_vals[t1.to_s][t2.to_s]
        arr1 = Array.new(size){ vals["small"][rand(0..1)] }
        arr2 = Array.new(size){ vals["large"][rand(0..1)] }
        if t2.to_s == "sorted"
            arr1.sort!
            arr2.sort!
        elsif t2.to_s == "reversed"
            arr1.sort!.reverse!
            arr2.sort!.reverse!
        end
        return [arr1, arr2]
    end


    def self.sorted?(arr)
        return true if arr.length <= 1
        (1...arr.length).each do |i|
            return false if arr[i] < arr[i-1]
        end
        return true
    end


    def self.time(&proc)
        t1 = Time.now
        val = proc.call()
        return { time: (Time.now - t1)*1000, val: val }
    end


    def self.make_array(n, type)
        max = 100000
        case type
            when :random
                 return Array.new(n){ rand(-max...max) }
            when :sorted
                 return (1..n).to_a
            when :reversed
                 return (1..n).to_a.reverse
            when :floats
                 return Array.new(n){ rand(0.0...max).round(3) }
            when :strings
                 return Array.new(n){ rand_string( rand(1..100) ) }
        end
    end



    def self.rand_string(n)
        return Faker::Alphanumeric.alphanumeric(number: n)
    end


    def self.wght_avg(arr)
        wght_div = (arr.length*(arr.length+1))/2.0
        return arr.sort.each_with_index.inject(0) do |acc, (e, i)|
            acc += ((i+1)/wght_div)*e
        end
    end


    def self.log_scale(i)
        n = 10**(i+1)
        return 10*Math::log(10*n, n)
    end


    def self.is_number?(obj)
        return obj.to_f.to_s == obj.to_s || obj.to_i.to_s == obj.to_s
    end

end
