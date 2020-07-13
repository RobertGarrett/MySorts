require_relative "./Util"
require_relative "./Config"
require "byebug"


module Timer
    @@len_1 = 5 + Config.CONFIG["sort_order"].max_by(&:length).length
    @@len_2 = 13


    def self.run(sym)
        header = "_"*@@len_1
        [10, 100, 1000, 10000, 100000].each do |size|
            header += "|_" + ("%-#{@@len_2}s" % "n=#{size}").gsub(' ', "_")
        end
        puts "\n\n" + header + "|__________________#{sym.to_s.upcase}"

        @@type_run = Config.DATA_TYPES.include?(sym)
        @@type_run ? run_by_data_type(sym) : run_by_sort(sym)
    end


    def self.run_by_data_type(type)
        @@type = type
        config = Config.CONFIG
        sorts = config["sort_order"].reject do |sort|
            config["sorts"][sort]["data_exceptions"].include?(type.to_s)
        end
        sorts = sorts.map { |sort| Object.const_get(sort) }
        sorts.each { |sort| sort.time_all }
    end


    def self.run_by_sort(sort)
        clazz = Object.const_get(sort.to_s)
        exceptions = Config.CONFIG["sorts"][sort.to_s]["data_exceptions"]
        types = Config.DATA_TYPES - exceptions.map(&:to_sym)

        types.each do |type|
            @@type = type
            clazz.time_all
        end
    end


    def time_all()
        times = { 10 => nil, 100 => nil, 1000 => nil, 10000 => nil, 100000 => nil}
        times.each do |k, v|
            break if isException(k)
            times[k] = time( Util.make_array(k, @@type) )
        end
        self.print_results(times)
    end


    def time(to_sort, runs = 5)
        total = 0
        runs.times do
            time_hash = Util.time{ self.sort(to_sort.clone) }

            unless Util.sorted?( time_hash[:val] )
                puts "#{("%-#{@@len_1}s" % self.name).gsub(' ', '-')} FAILED"
                debugger
                return
            end
            total += time_hash[:time]
        end
        return total / runs
    end


private


    def print_results(times)
        tag = @@type_run ? self.name : @@type.to_s
        output = "#{("%-#{@@len_1}s" % tag).gsub(' ', '-')}"
        times.each do |k, v|
            time = v.nil? ? "-"*(@@len_2-3) : "%#{@@len_2-3}.3f" % (v)
            output += "| #{time} ms"
        end
        puts output + "|  ~ #{get_big_O(times)}"
    end


    def get_big_O(times)
        vals = times.values.reject(&:nil?)
        ratios = (0...vals.length-1).map { |i| vals[i+1] / vals[i] }
        range = (0...ratios.length)

        comparisons = {
            "n" =>       Util.wght_avg( range.map { |i| ratios[i] / 10 } ),
            "nlog(n)" => Util.wght_avg( range.map { |i| ratios[i] / Util.log_scale(i) } ),
            "n^2" =>     Util.wght_avg( range.map { |i| ratios[i] / 100 } )
        }
        min = comparisons.min_by { |k, v| (v + 1/v)/2.0 }

        return min[0] if min[0] != "n"
        special = { "nk" => test_nk(), "n+k" => test_n_plus_k() }
        max = special.max_by{ |k, v| v }
        return max[1] >= 2.0 ? max[0] : "n"
    end


    def test_nk()
        arr1, arr2 = Util.make_special_arrays(100, "nk", @@type)
        timed_ratio = time( arr2.clone )/time( arr1.clone )
        return timed_ratio
    end


    def test_n_plus_k()
        return 0.0 if @@type == :strings
        arr1, arr2 = Util.make_special_arrays(100, "n+k", @@type)
        timed_ratio = time( arr2.clone )/time( arr1.clone )
        return timed_ratio
    end


    def isException(num)
        max = Config.CONFIG["sorts"][self.name]["no_run"][@@type.to_s]
        return max && max <= num
    end

end
