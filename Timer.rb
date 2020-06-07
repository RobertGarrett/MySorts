require "faker"

module Timer
    @@len_1 = 25
    @@len_2 = 10

    def self.header(type)
        header = "_"*@@len_1
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=100').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=1000').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=10000').gsub(' ', "_")
        header += "|_" + ("%-#{@@len_2+3}s" % 'n=100000').gsub(' ', "_")

        puts "\n\n" + header + "|__________________#{type.to_s.upcase}"
    end

    def time_all(type, doLarge = true)
        times = {100 => 0, 1000 => 0, 10000 => -1, 100000 => -1}
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
                    times[k] = self.time( Array.new(k) { (rand())*10000 }, false )
                when :strings
                    times[k] = self.time(
                        Array.new(k){ Faker::Alphanumeric.alphanumeric(number: 100) },
                        false
                    )
            end
            break if times[k] == nil
        end

        output = "#{("%-#{@@len_1}s" % self.name).gsub(' ', '-')}"
        times.each { |k, v| output += "| #{"%#{@@len_2}.3f" % (v)} ms" }

        vals = times.values.reject { |val| val < 0 }
        avg_scale = (0...vals.length-1).inject(0) { |acc, i| acc += vals[i+1] / vals[i] }
        avg_scale /= vals.length - 1

        if avg_scale < 10.5
            output += "|  <= n"
        elsif avg_scale < 50
            output += "|  ~ nlog(n)"
        else
            output += "|  >= n^2"
        end

        puts output
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

    def time_random
        time Array.new(10000){rand(0...10000)}
    end

    def time_sorted
        time (1..n).to_a
    end

    def time_reversed
        time (1..n).to_a.reverse
    end

end
