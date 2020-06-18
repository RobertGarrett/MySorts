require "faker"
require "byebug"

SORT_EXCEPTIONS = JSON.parse( File.read("sort_exceptions.json") )

module Timer
    @@len_1 = 25
    @@len_2 = 13
    @@type = nil


    def self.header(type)
        @@type = type
        header = "_"*@@len_1
        header += "|_" + ("%-#{@@len_2}s" % 'n=100').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2}s" % 'n=10^3').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2}s" % 'n=10^4').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2}s" % 'n=10^5').gsub(' ', "_")

        puts "\n\n" + header + "|__________________#{type.to_s.upcase}"
    end

    def time_all(type)
        times = { 100 => nil, 1000 => nil, 10000 => nil, 100000 => nil}
        times.each do |k, v|
            break if isException(k)
            times[k] = time( make_array(k), false )
        end
        self.print_results(times)
    end



    def time(to_sort, print = true)
        total = 0
        5.times do
            arr = to_sort.clone

            t1 = Time.now
            sorted = self.sort(arr)
            t2 = Time.now

            compare = arr.sort
            if compare == sorted
                total += (t2-t1)*1000
            else
                comp = []
                (0..arr.length).each { |i| comp << i if compare[i] != sorted[i] }
                puts "#{('%-25.25s' % self.name).gsub(' ', '-')} FAILED"
                return
            end
        end

        if print
            puts "#{('%-25.25s' % self.name).gsub(' ', '-')}| #{'%10.3f' % (total / 5)} ms"
        else
            return total / 5
        end
    end

private

    def print_results(times)
        output = "#{("%-#{@@len_1}s" % self.name).gsub(' ', '-')}"
        times.each do |k, v|
            time = v.nil? ? "-"*(@@len_2-3) : "%#{@@len_2-3}.3f" % (v)
            output += "| #{time} ms"
        end
        puts output + "|  ~ #{get_big_O(times)}"
    end

    def get_big_O(times)
        vals = times.values.reject { |val| !val }
        ratios = (0...vals.length-1).map { |i| vals[i+1] / vals[i] }
        range = (0...ratios.length)

        comparisons = {
            "n" =>
                avg( range.map { |i| ratios[i] / 10 } ),
            "nlog(n)" =>
                avg( range.map { |i| ratios[i] / log_scale( 10**(i+1) ) } ),
            "n^2" =>
                avg( range.map { |i| ratios[i] / 100 } )
        }
        min = comparisons.min_by do |k, v|
            # Here, v + 1/v is used to account for fractional ratios
            # i.e, ratios of .5 and 2 are treated as "equal"
            (v + 1/v) - 1
        end
        return min[0] == "n" && self.is_length_dependent ? "nk" : min[0]
    end

    def log_scale(n)
        return 10*Math::log(10*n, n)
    end

    def is_length_dependent()
        arr1 = make_array(1000, 1)
        arr2 = make_array(1000, 5)
        ratio = time(arr1, false)/time(arr2, false)
        return ratio < 0.9
    end

    def make_array(n, k = nil)
        max = k ? 10**k : 100000
        case @@type
            when :random
                 return Array.new(n){ rand(1..max) }
            when :sorted
                 return k.nil? ? (1..n).to_a : (max..(max+n)).to_a
            when :reversed
                return k.nil? ? (1..n).to_a.reverse : (max..(max+n)).to_a.reverse
            when :floats
                 return Array.new(n){ rand(0.0...max).round(3) }
            when :strings
                 return Array.new(n){ rand_string(k || 100) }
        end
    end

    def rand_string(n)
        return Faker::Alphanumeric.alphanumeric(number: n)
    end

    def isException(num)
        exceptions = SORT_EXCEPTIONS[self.name];
        return exceptions && (exceptions[@@type.to_s] || 10**10) <= num
    end

    def median(array)
        sorted = array.sort
        len = sorted.length
        (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
    end
    def avg(array)
        return array.sum / array.length
    end

end
