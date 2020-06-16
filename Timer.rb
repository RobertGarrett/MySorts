require "faker"
require "byebug"

module Timer
    @@len_1 = 25
    @@len_2 = 10
    @@val_length = 0;

    def self.header(type)
        header = "_"*@@len_1
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=10').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=100').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=1000').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=10000').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=100000').gsub(' ', "_")

        puts "\n\n" + header + "|__________________#{type.to_s.upcase}"
    end

    def time_all(type, doLarge = true)
        times = { 10 => 0, 100 => 0, 1000 => 0, 10000 => -1, 100000 => -1}
        times.each do |k, v|
            break if k >= 10000 && !doLarge
            case type
                when :random
                    times[k] = self.time( Array.new(k) {rand(0...k)}, false );
                when :sorted
                    times[k] = self.time( (1..k).to_a, false )
                when :reversed
                    times[k] = self.time( (1..k).to_a.reverse, false )
                when :floats
                    times[k] = self.time( Array.new(k) { (rand(0.0...k)).round(3) }, false )
                when :strings
                    times[k] = self.time( Array.new(k){ self.rand_string(k) }, false )
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
        puts output + "|  ~ #{get_big_O(times)}"
    end

    def get_big_O(times)
        vals = times.values.reject { |val| val < 0 }
        ratios = (0...vals.length-1).map { |i| vals[i+1] / vals[i] }
        range = (0...ratios.length)

        comparisons = {
            "n" => range.map { |i| ratios[i] / 10 },
            #"n+k" => range.map { |i| ratios[i] / n_plus_k_scale( 10**(i+1) ) },
            "nlog(n)" => range.map { |i| ratios[i] / log_scale( 10**(i+1) ) },
            "n^2" => range.map { |i| ratios[i] / 100 }
        }
        comparisons = comparisons.map { |k, arr| [k, avg(arr)] }.to_h

        # Since v +1/v = (v+1)/v > 1, no need to take absolute value
        return comparisons.min_by { |k, v| (v + 1/v) - 1 }[0]
    end

    def log_scale(n)
        return 10*Math::log(10*n, n)
    end

    def n_plus_k_scale(n)
        digits = n.to_s.length
        return (10.0*n + digits+1)/(n + digits)
    end

    def rand_string
        return Faker::Alphanumeric.alphanumeric(number: 100)
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
