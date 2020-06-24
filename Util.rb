class Util

    @@SORT_CONFIG = JSON.parse( File.read("sort_config.json") )
    @@special_vals = {
        "nk" => {
            default: { small:    [ 10, 90], large:    [ 111111110, 111111190] },
            floats:  { small:  [ 9.0, 1.0], large:  [ 11111119.0, 11111111.0] },
            strings: { small: ["zz", "aa"], large: ["aaaaaaazz", "aaaaaaaaa"] }
        },
        "n+k" => {
            default: { small:     [10000, 0], large:     [1000000, 0] },
            floats:  { small: [10000.0, 0.0], large: [1000000.0, 0.0] },
            strings: { small: ["abcde", "a"], large: ["abcdefg", "a"] }
        }
    }
    @@special_vals["nk"].default  = @@special_vals["nk"][:default]
    @@special_vals["n+k"].default = @@special_vals["n+k"][:default]



    def self.config
        return @@SORT_CONFIG
    end

    def self.make_special_arrays(size, t1, t2)
        vals = @@special_vals[t1][t2]
        arr1 = Array.new(size){ vals[:small][rand(0..1)] }
        arr2 = Array.new(size){ vals[:large][rand(0..1)] }
        if t2 == :sorted
            arr1.sort!
            arr2.sort!
        elsif t2 == :reversed
            arr1.sort!.reverse!
            arr2.sort!.reverse!
        end
        return [arr1, arr2]
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
                 return Array.new(n){ rand(1...max) }
            when :sorted
                 return (1..n).to_a
            when :reversed
                return (1..n).to_a.reverse
            when :floats
                 return Array.new(n){ rand(0.0...max).round(3) }
            when :strings
                 return Array.new(n){ rand_string(100) }
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
