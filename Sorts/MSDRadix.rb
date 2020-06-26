require_relative '../Timer'
require_relative './Insertion'
require "byebug"

class MSDRadix
    extend Timer

    @@optimizer = nil
    @@min_length = nil
    @@type = nil

    # Due to Float rounding errors, there may be some inaccuracies after using
    # the radix sort. To eliminate these, we utilize an insertion sort
    # since it is ~O(n) for nearly sorted arrays.
    def self.sort( arr, opts = {} )
        @@optimizer = opts[:optimizer]
        @@min_length = opts[:min_length]

        @@type = arr[0].is_a?(Numeric) ? Numeric : arr[0].class
        all_same_type = arr.all? { |e| e.is_a?(@@type) }

        return arr if arr.length <= 1 || !all_same_type

        if @@type == Numeric
            positives = arr.reject { |e| e < 0 }
            negatives = arr - positives

            if positives.size > 1
                positives = sort_partial(positives)
            end
            if negatives.size > 1
                negatives = sort_partial(negatives)
            end

            # Note that sense -3 % 10 = 10-3 = 7, the negatives array is already
            # sorted backwards, so there is no need to reverse it.
            return Insertion.sort( negatives + positives )
        else
            return @@type != String ? arr : sort_partial(arr)
        end
    end

    def self.sort_partial(arr)
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
        if @@optimizer && arr.length <= @@min_length
            return @@optimizer.call(arr), true
        elsif (0...arr.length).all?{ |i| arr[i] == arr[0] }
            return arr, true
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
