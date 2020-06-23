require_relative "../Timer"
require "byebug"

class Pigeonhole
    extend Timer

    def self.sort(arr)
        min, max = [arr.min, arr.max]
        phole = Array.new(max - min + 1){Array.new}
        arr.each { |e| phole[e-min] << e }
        return phole.flatten
    end

end
