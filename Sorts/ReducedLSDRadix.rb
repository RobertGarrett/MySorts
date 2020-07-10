require_relative '../Timer'
require_relative 'Insertion'
require "byebug"

class ReducedLSDRadix
    extend Timer

    @@base32 = %w(0 1 2 3 4 5 6 7 8 9 a b c d e f g h
                  i j k l m n o p q r s t u v w x y z)

    # Faster than regular LSD for very long integers, but suffers from
    # technical cost of converting to base32 and back. Will attempt to
    # find a faster solution
    def self.sort(arr)
        positives = arr.reject { |e| e < 0 }
        negatives = arr - positives

        if positives.length > 1
            positives.map!{ |e| e.to_s(36) }
            max = positives.max_by(&:length).length
            (1..max).each do |i|
                positives = counting_sort(positives, i)
            end
        end
        if negatives.length > 1
            negatives.map!{ |e| e.to_s(36) }
            max = negatives.max_by(&:length).length - 1
            (1..max).each do |i|
                negatives = counting_sort(negatives, i)
            end
            negatives.reverse!
        end
        return (negatives + positives).map { |e| e.to_i(36) }
    end

    def self.counting_sort(input_arr, exp)
        count_arr = create_count_arr(input_arr, exp)
        result = Array.new( input_arr.size )

        (input_arr.size-1).downto(0).each do |i|
            item = input_arr[i]
            sig = get_sig(item, exp)
            count_arr[sig] += -1
            result[count_arr[sig]] = item
        end

        return result
    end

    def self.create_count_arr(arr, exp)
        count_arr = Hash.new(0)
        arr.each do |item|
            sig = get_sig(item, exp)
            count_arr[ sig ] += 1
        end
        (1...36).each { |i| count_arr[@@base32[i]] += count_arr[@@base32[i-1]] }
        return count_arr
    end

    def self.get_sig(item, exp)
        return [nil, "-"].include?(item[-exp]) ? "0" : item[-exp]
    end

end
