require_relative '../Timer'
require_relative './Insertion'

class MSDRadix
    extend Timer

    # Due to Float rounding errors, there may be some inaccuracies after using
    # the radix sort. To eliminate these, we utilize an insertion sort
    # since it is ~O(n) for nearly sorted arrays.
    def self.sort(arr)
        return arr if arr.length <= 1

        final = []
        array_stack = [arr]
        idx_stack = [arr.max.to_i.digits.length-1]

        while array_stack.length > 0
            current = array_stack.pop
            idx = idx_stack.pop

            result, add = counting_sort(current, idx)
            if add
                final.push(*result)
            else
                array_stack.push(*result)
                idx_stack.push( *Array.new(result.length, idx-1) )
            end
        end
        return Insertion.sort(final)
    end

    def self.counting_sort(arr, exp)
        if (0...arr.length).all?{ |i| arr[i] == arr[0] }
            return arr, true
        end

        bkts = Array.new(10){ Array.new }

        n = 10**exp
        m = 10*n

        arr.each { |e| bkts[(e%m)/n] << e }
        bkts.reject! { |bucket| bucket.empty?}
        return bkts.reverse, false
    end

end
