require_relative '../Timer'
#require_relative "../Util"
require_relative './Insertion'
require "byebug"

class MSDRadix
    extend Timer

    # Due to Float rounding errors, there may be some inaccuracies after using
    # the radix sort. To eliminate these, we utilize an insertion sort
    # since it is ~O(n) for nearly sorted arrays.
    def self.sort( arr, opts = {} )
        @@optimizer = opts[:optimizer]
        @@min_length = opts[:min_length]
        @@type = arr[0].is_a?(Numeric) ? Numeric : arr[0].class

        return arr if arr.length <= 1 || Util.is_uniform_type?(arr)

        if @@type == Numeric
            positives = arr.reject { |e| e < 0 }
            negatives = arr - positives

            # Note that sense -3 % 10 = 10-3 = 7, the negatives array is already
            # sorted backwards, so there is no need to reverse it.
            arr = sort_main(negatives) + sort_main(positives)
            return Insertion.sort( arr )
        else
            return @@type != String ? arr : sort_main(arr)
        end
    end

    def self.sort_main(arr)
        return arr if arr.length <= 1

        final, arr_stack = [ [], [arr] ]
        idx_stack = [ @@type == String ? 0 : get_start(arr)]
        dir = @@type == String ? 1 : -1

        while arr_stack.length > 0
            idx = idx_stack.pop
            result, add = sort_delegator(arr_stack.pop, idx)
            if add
                final.push(*result)
            else
                arr_stack.push(*result)
                idx_stack.push( *Array.new(result.length, idx + dir) )
            end
        end
        return final
    end

    def self.get_start(arr)
        return [arr.min.abs, arr.max.abs].max.to_i.to_s.length - 1
    end



    def self.sort_delegator(arr, exp)
        if (0...arr.length).all?{ |i| arr[i] == arr[0] }
            return arr, true
        elsif @@optimizer && arr.length <= @@min_length
            return @@optimizer.call(arr), true
        else
            return sort_strings(arr, exp) if @@type == String
            return sort_nums(arr, exp)
        end
    end



    def self.sort_nums(arr, exp)
        bkts = Array.new(10){ Array.new }
        n, m = [ 10**exp, 10**(exp+1) ]

        arr.each { |e| bkts[(e%m)/n] << e }
        bkts.reject! { |bucket| bucket.empty?}
        return bkts.reverse, false
    end



    def self.sort_strings(arr, n)
        bkts = Hash.new { |h, k| h[k] = [] }
        nils = []

        arr.each do |item|
            sig = item[n]
            bkt = sig ? bkts[sig] : nils
            bkt << item
        end
        bkts = bkts.sort_by { |k, v| k }.to_h.values
        return bkts.reverse + [nils], false
    end

end
