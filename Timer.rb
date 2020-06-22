require "faker"
require "byebug"
require_relative "./Util"



SORT_EXCEPTIONS = JSON.parse( File.read("sort_exceptions.json") )

SPECIAL_ARRAYS = {
    "nk" => {
        random:   [ [90, 10], [111111190, 111111110] ],
        sorted:   [ [10, 90], [111111110, 111111190] ],
        reversed: [ [90, 10], [111111190, 111111110] ],
        floats:   [ [9.0, 1.0], [11111119.0, 11111111.0] ],
        strings:  [ ["zz", "aa"], ["aaaaaaazz", "aaaaaaaaa"]]
    },
    "n+k" => {
        random:   [ [10000, 0], [1000000, 0] ],
        sorted:   [ [0, 10000], [0, 1000000] ],
        reversed: [ [10000, 0], [1000000, 0] ],
        floats:   [ [10000.0, 0.0], [1000000.0, 0.0] ],
        strings:  [ ["abcde", "a"], ["abcdefg", "a"] ]
    }
}



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
            times[k] = time( Util.make_array(k, @@type), false )
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
            if compare != sorted
                comp = []
                (0..arr.length).each { |i| comp << i if compare[i] != sorted[i] }
                puts "#{('%-25.25s' % self.name).gsub(' ', '-')} FAILED"
                return
            end
            total += (t2-t1)*1000
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
        times
        puts output + "|  ~ #{get_big_O(times)}"
    end

    def get_big_O(times)
        vals = times.values.reject { |val| !val }
        ratios = (0...vals.length-1).map { |i| vals[i+1] / vals[i] }
        range = (0...ratios.length)

        comparisons = {
            "n" =>       Util.avg( range.map { |i| ratios[i] / 10 } ),
            "nlog(n)" => Util.avg( range.map { |i| ratios[i] / Util.log_scale(i) } ),
            "n^2" =>     Util.avg( range.map { |i| ratios[i] / 100 } )
        }

        # Here, v + 1/v is used to account for fractional ratios
        # i.e, ratios of .5 and 2 are treated as "equal"
        min = comparisons.min_by { |k, v| (v + 1/v) - 1 }

        if min[0] == "n"
            return "n+k" if self.test_n_plus_k
            return "nk" if self.test_nk
            return "n"
        else
            return min[0]
        end
    end

    def test_nk()
        arr1, arr2 = SPECIAL_ARRAYS["nk"][@@type]
        timed_ratio = time( arr2.clone, false )/time( arr1.clone, false )
        return timed_ratio >= 2.0
    end

    def test_n_plus_k()
        return false if @@type == :strings
        arr1, arr2 = SPECIAL_ARRAYS["n+k"][@@type]
        timed_ratio = time( arr2.clone, false )/time( arr1.clone, false )
        return timed_ratio >= 10.0
    end


    def isException(num)
        exceptions = SORT_EXCEPTIONS[self.name];
        return exceptions && (exceptions[@@type.to_s] || 10**10) <= num
    end

end
