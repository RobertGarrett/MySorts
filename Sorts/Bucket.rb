require_relative "../Timer"
require_relative "./Insertion"
require "byebug"

class Bucket
    extend Timer

    def self.sort(arr, bucket_size = 10)
        return if arr.empty?

        max, min = [arr.max, arr.min]
        bucket_count = ((max - min) / bucket_size).floor + 1
        buckets = Array.new(bucket_count)

        arr.each do |e|
            idx = ( (e - min)/bucket_size ).floor
            buckets[idx] ? buckets[idx].push(e) : buckets[idx] = [e]
        end
        buckets = buckets.compact.map { |bucket| Insertion.sort(bucket) }
        return buckets.flatten
    end

end
