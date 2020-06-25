require_relative '../Timer'
require_relative './Insertion'
require "byebug"

class MSDRadix
    extend Timer

    # Due to Float rounding errors, there may be some inaccuracies after using
    # the radix sort. To eliminate these, we utilize an insertion sort
    # since it is ~O(n) for nearly sorted arrays.
    def self.sort(arr)
        return arr if arr.length <= 1
        is_str_arr = arr.all? { |e| e.instance_of?(String) }

        positives = arr.reject { |e| e < 0 }
        negatives = arr - positives
        if positives.size > 1
            positives = sort_helper(positives, is_str_arr)
        end
        if negatives.size > 1
            negatives = sort_helper(negatives, is_str_arr)
        end

        # Note that sense -3 % 10 = 10-3 = 7, the negatives array is already
        # sorted backwards, so there is no need to reverse it.
        return Insertion.sort( negatives + positives )
    end

    def self.sort_helper(arr, is_str_arr)
        final, arr_stack, idx_stack = [ [], [arr], get_max(arr, is_str_arr) ]

        dir = is_str_arr ? 1 : -1
        counting_sort = self.method( is_str_arr ? :counting_sort_strings : :counting_sort_nums )

        while arr_stack.length > 0
            idx = idx_stack.pop
            result, add = counting_sort.call(arr_stack.pop, idx)
            if add
                final.push(*result)
            else
                arr_stack.push(*result)
                idx_stack.push( *Array.new(result.length, idx + dir) )
            end
        end
        return final
    end

    def self.get_max(arr, is_str_arr)
        idx_stack = []
        if is_str_arr
            idx_stack << 0
        else
            max_str = [arr.min.abs, arr.max.abs].max.abs.to_s
            max = max_str.split(".").inject(0) { |acc, s| acc += s.length }
            idx_stack << max - 1
        end
        return idx_stack
    end

    def self.counting_sort_nums(arr, exp)
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


    def self.counting_sort_strings(arr, n)
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
        keys = bkts.keys.sort { |k1, k2| k2 <=> k1 } # Ruby uses a QuickSort
        keys.each do |char|
            stack << bkts[char] if bkts[char].length != 0
        end
        stack << nils if nils.length >= 1

        return stack, false
    end

end
