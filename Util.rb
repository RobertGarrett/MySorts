class Util
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

    def self.median(array)
        sorted = array.sort
        len = sorted.length
        (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
    end

    def self.avg(array)
        return array.sum / array.length
    end

    def self.log_scale(i)
        n = 10**(i+1)
        return 10*Math::log(10*n, n)
    end

end
