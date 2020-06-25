require_relative "./Util"
require "byebug"


module Timer
    @@len_1 = 25
    @@len_2 = 13
    @@type = nil


    def self.run(type)
        @@type = type
        header = "_"*@@len_1
        [100, 1000, 10000, 100000].each do |size|
            header += "|_" + ("%-#{@@len_2}s" % "n=#{size}").gsub(' ', "_")
        end
        puts "\n\n" + header + "|__________________#{type.to_s.upcase}"

        config = Util.config
        sorts = config["Sort_Order"].reject do |sort|
            config["Sorts"][sort]["data_exceptions"].include?(type.to_s)
        end
        sorts = sorts.map { |sort| Object.const_get(sort) }
        sorts.each { |sort| sort.time_all }
    end

    def time_all
        times = { 100 => nil, 1000 => nil, 10000 => nil, 100000 => nil}
        times.each do |k, v|
            break if isException(k)
            times[k] = time( Util.make_array(k, @@type), 5 )
        end
        self.print_results(times)
    end

    def time(to_sort, num_times = 5)
        total = 0
        num_times.times do
            arr = to_sort.clone
            time_hash = Util.time{ self.sort(arr) }

            if arr.sort != time_hash[:val]
                comp = arr.sort.reject { |e| time_hash[:val] == e}
                puts "#{("%-#{@@len_1}s" % self.name).gsub(' ', '-')} FAILED"
                debugger
                return
            end
            total += time_hash[:time]
        end
        return total / 5
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
            "n" =>       Util.wght_avg( range.map { |i| ratios[i] / 10 } ),
            "nlog(n)" => Util.wght_avg( range.map { |i| ratios[i] / Util.log_scale(i) } ),
            "n^2" =>     Util.wght_avg( range.map { |i| ratios[i] / 100 } )
        }
        min = comparisons.min_by { |k, v| (v + 1/v)/2.0 }

        return min[0] if min[0] != "n"
        return "n+k" if self.test_n_plus_k
        return "nk" if self.test_nk
        return "n"
    end

    def test_nk()
        arr1, arr2 = Util.make_special_arrays(1000, "nk", @@type)
        timed_ratio = time( arr2.clone )/time( arr1.clone )
        return timed_ratio >= 2.0
    end

    def test_n_plus_k()
        return false if @@type == :strings
        arr1, arr2 = Util.make_special_arrays(1000, "n+k", @@type)
        timed_ratio = time( arr2.clone )/time( arr1.clone )
        return timed_ratio >= 2.0
    end

    def isException(num)
        max = Util.config["Sorts"][self.name]["no_run"][@@type.to_s]
        return max && max <= num
    end

end
