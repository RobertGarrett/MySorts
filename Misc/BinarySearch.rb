class BinarySearch
    def self.insert_idx(arr, x, opts={})
        l, r = [opts[:lb] || 0, opts[:rb] || (arr.length - 1)]

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
