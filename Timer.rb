require "faker"
require "byebug"

module Timer
    @@len_1 = 25
    @@len_2 = 10

    def self.header(type)
        header = "_"*@@len_1
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=10').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=100').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=1000').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=10000').gsub(' ', "_")
        #header += "|_" + ("%-#{@@len_2+3}s" % 'n=100000').gsub(' ', "_")

        puts "\n\n" + header + "|__________________#{type.to_s.upcase}"
    end

    def time_all(type, doLarge = true)
        times = { 10 => 0, 100 => 0, 1000 => 0, 10000 => -1}
        times.each do |k, v|
            break if k >= 10000 && !doLarge
            case type
                when :random
                    times[k] = self.time( Array.new(k) {rand(0...10000)}, false )
                when :sorted
                    times[k] = self.time( (1..k).to_a, false )
                when :reversed
                    times[k] = self.time( (1..k).to_a.reverse, false )
                when :floats
                    times[k] = self.time( Array.new(k) { (rand()).round(3) }, false )
                when :strings
                    times[k] = self.time( Array.new(k){ rand_string() }, false )
            end
        end

        self.print_results(times)
    end



    def time(toSort, print = true)
        total = 0
        5.times do
            arr = toSort.clone

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
                debugger
                print "\n" + comp.to_s + "\n\n"
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
        times.each { |k, v| output += "| #{"%#{@@len_2}.3f" % (v)} ms" }

        case get_big_O(times)
            when :linear
                output += "|  ~ n"
            when :nlogn
                output += "|  ~ nlog(n)"
            when :quad
                 output += "|  ~ n^2"
        end

        puts output
    end

    def get_big_O(times)
        vals = times.values.reject { |val| val < 0 }
        ratios = (0...vals.length-1).map { |i| vals[i+1] / vals[i] }
        range = (0...ratios.length)
        n = range.map { |i| ratios[i] / 10 }
        nlogn = range.map { |i| ratios[i] / self.log_scale( 10**(i+2) ) }
        n2 = range.map { |i| ratios[i] / 100 }

        medians = [n, nlogn, n2].map { |arr| self.median(arr) }
        min = medians.min_by { |x| (1-x).abs }
        if min == medians[0]
            return :linear
        elsif min == medians[1]
            return :nlogn
        elsif min == medians[2]
            return :quad
        end
    end

    def log_scale(n)
        return 10*Math::log(10*n, n)
    end

    def rand_string
        return Faker::Alphanumeric.alphanumeric(number: 100)
    end

    def median(array)
        sorted = array.sort
        len = sorted.length
        (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
    end

end
