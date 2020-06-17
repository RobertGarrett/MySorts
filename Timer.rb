require "faker"
require "byebug"

SORT_EXCEPTIONS = JSON.parse( File.read("sort_exceptions.json") )

module Timer
    @@len_1 = 25
    @@len_2 = 13
    @@is_float = false;

    def sort_exceptions
        return @@sort_exceptions
    end


    def self.header(type)
        header = "_"*@@len_1
        header += "|_" + ("%-#{@@len_2}s" % 'n=10').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2}s" % 'n=100').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2}s" % 'n=1000').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2}s" % 'n=10000').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2}s" % 'n=100000').gsub(' ', "_")

        puts "\n\n" + header + "|__________________#{type.to_s.upcase}"
    end

    def time_all(type)
        times = { 10 => nil, 100 => nil, 1000 => nil, 10000 => nil, 100000 => nil}
        @@is_float = type == :float

        times.each do |k, v|
            break if self.isException(type, k)
            @@is_float = false;
            n = 2**(k.digits.length)
            case type
                when :random
                    times[k] = self.time( Array.new(k) {rand(1..k)}, false );
                when :sorted
                    times[k] = self.time( (1..k).to_a, false )
                when :reversed
                    times[k] = self.time( (1..k).to_a.reverse, false )
                when :floats
                    times[k] = self.time( Array.new(k) { (rand(0.0...k)).round(3) }, false )
                when :strings
                    times[k] = self.time( Array.new(k){ self.rand_string(n) }, false )
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
            "n" => range.map { |i| ratios[i] / 10 },
            #"nk" => range.map { |i| ratios[i] / nk_scale( 10**(i+1) ) },
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

    def nk_scale(n)
        length = n.to_s.length
        length -= 1 if @@is_float
        return (10.0*n + length+1)/(n + length)
    end

    def rand_string(n)
        return Faker::Alphanumeric.alphanumeric(number: n)
    end

    def isException(sym, num)
        exceptions = SORT_EXCEPTIONS[self.name];
        return exceptions && (exceptions[sym.to_s] || 10**10) <= num
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
