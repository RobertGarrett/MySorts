require_relative '../Timer'
require_relative 'Insertion.rb'
require_relative 'MSDRadix'

class OptimizedMSDRadix
    extend Timer

    def self.sort(arr)
        opts = {
            optimizer: Proc.new{ |array| Insertion.sort(array) },
            min_length: 10
        }
        return MSDRadix.sort(arr, opts)
    end

end
