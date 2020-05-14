class BinarySearch
    def self.insert_idx(arr, x)
        l , r = 0, arr.length - 1
        while l <= r
            m = (l+r)/2;

            if arr[m] == x
                return m
            elsif arr[m] < x
                l = m+1
            else
                r = m-1
            end
        end
        return l
    end
end



if __FILE__ == $PROGRAM_NAME
    arr = (0..100000000).to_a
    t = Time.now
    print BinarySearch.insert_idx(arr, 5).to_s + "\n\n"
    print "#{(Time.now - t)*1000} ms\n\n"
end
