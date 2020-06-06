require_relative 'Timer'
require "byebug"

# As one would expect of a Bucket based sort, this proves VERY effective
# when n is much larger than the length of the string. Generally, this
# seems to be much faster than a QuickSort or InsertionSort for short
# strings. As opposed to a radix type sort, this also terminates early
# when

class MyStringBucket
    extend Timer

    def self.sort(arr)
        return arr if arr.length <= 1

        final = []
        array_stack = [arr]
        idx_stack = [0]

        while array_stack.length > 0
            idx = idx_stack.pop
            result, add = counting_sort(array_stack.pop, idx)
            if(add)
                final += result
            else
                array_stack += result
                idx_stack += Array.new(result.length, idx+1)
            end
        end
        return final
    end

    def self.counting_sort(arr, n)
        if (0...arr.length).all?{ |i| arr[i] == arr[0] }
            return arr, true
        end

        bkts = Hash.new { |h, k| h[k] = [] }
        nils = []
        add_to_buckets(bkts, arr, nils, n)

        return get_stack_additions(bkts, nils)
    end

    def self.add_to_buckets(bkts, arr, nils, n)
        arr.each do |item|
            if item[n]
                bkts[ item[n] ] << item
            else
                nils << item
            end
        end
    end

    def self.get_stack_additions(bkts, nils)
        stack = []
        keys = bkts.keys.sort { |k1, k2| k2 <=> k1 }
        keys.each do |char|
            stack << bkts[char] if bkts[char].length >= 1
        end
        stack << nils if nils.length >= 1

        return stack, false
    end
end
