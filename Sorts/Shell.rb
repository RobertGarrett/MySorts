require_relative "../Timer"

class Shell
    extend Timer

    def self.sort(arr)
        n = arr.length
        gap = n
        while (gap /= 2) > 0
            (gap...n).each do |i|
                while arr[i-gap] > arr[i]
                    arr[i-gap], arr[i] = arr[i], arr[i-gap]
                    i -= gap
                    break if i - gap < 0
                end
            end
        end
        return arr
    end

end
