require_relative 'Insertion.rb'

class InsertionStringRadix

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
        if arr.length <= 10
            return InsertionSort.sort(arr), true
        elsif (0...arr.length).all?{ |i| arr[i] == arr[0] }
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
        keys = bkts.keys.sort { |k1, k2| k2 <=> k1 } # Ruby uses a QuickSort
        keys.each do |char|
            stack << bkts[char] if bkts[char].length >= 1
        end
        stack << nils if nils.length >= 1

        return stack, false
    end

end
