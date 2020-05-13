module Timer
    def time(arr)
        arr = arr.clone
        t1 = Time.now
        sorted = self.sort(arr)
        t2 = Time.now
        if sorted.sort == sorted
            puts "#{self.name} #{"-"*(25-self.name.length)} #{(t2 - t1)*1000} ms"
        else
            puts "#{self.name} #{"-"*(25-self.name.length)} FAILED"
            print "\n" + sorted.to_s + "\n\n"
        end
    end

    def sub_array_access_times
        arr = (1..1000000).to_a
        t1 = Time.now
        arr[0...1000000] = arr[0...1000000]
        t2 = Time.now
        copy_array(arr, arr)
        t3 = Time.now
        test = []
        t4 = Time.now
        times = {
            "Creation" => (t4-t3)*1000,
            "arr[a...b]" => (t2-t1)*1000,
            "loop copy" => (t3-t2)*1000
        }
        puts times
    end

    def ternary_speed
        t1 = Time.now
        if 1 == 2
            a = 4
        else
            a = 4
        end
        t2 = Time.now
        a = 1 == 2 ? 4 : 4
        t3 = Time.now
        times = {
            "if-else" => (t2-t1)*1000,
            "ternary" => (t3-t2)*1000
        }
        puts times
    end

    private

    def copy_array(a1, a2)
        (0...a1.length).each { |i| a1[i] = a2[i] }
    end
end
