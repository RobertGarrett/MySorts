require_relative "../Timer"

class Pigeonhole
    extend Timer

    def self.sort(arr)
        min, max = [arr.min, arr.max]
        phole = Array.new(max - min + 1){nil}
        arr.each do|e|
            phole[e-min] = [] unless phole[e-min]
            phole[e-min] << e
        end
        return phole.flatten.compact
    end

end
