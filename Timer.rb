module Timer
    @@random = Array.new(10000) { rand(0...100000000) }
    @@sorted = (1..10000).to_a

    def time(arr)
        arr = arr.clone
        t1 = Time.now
        sorted = self.sort(arr)
        t2 = Time.now
        if arr.sort == sorted
            puts "#{self.name} #{"-"*(25-self.name.length)} #{(t2-t1)*1000} ms"
        else
            puts "#{self.name} #{"-"*(25-self.name.length)} FAILED"
            print "\n" + sorted.to_s + "\n\n"
        end
    end

    def time_random
        time @@random
    end

    def time_sorted
        time @@sorted
    end

    def time_reversed
        time @@sorted.reverse
    end

end
