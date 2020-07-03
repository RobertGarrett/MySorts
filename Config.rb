require "json"

class Config
    @@CONFIG = JSON.parse( File.read("sort_config.json") )
    @@DATA_TYPES = [:random, :sorted, :reversed, :floats, :strings]

    def self.DATA_TYPES; @@DATA_TYPES; end
    def self.CONFIG; @@CONFIG; end
    def self.OPTIONS(sym)
        return @@OPTIONS[sym]
    end

    def self.create_data_options
        options = ["0) All"]
        @@DATA_TYPES.each_with_index do |type, idx|
            options << "\t#{idx+1}) #{type.to_s.capitalize}"
        end
        return options
    end

    def self.create_sort_options
        sorts = @@CONFIG["sort_order"]
        options = []

        even_elmnts = (0...sorts.size).step(2).map { |i| sorts[i] }
        max = even_elmnts.max_by(&:length).length

        (0...sorts.size).step(2).each do |i|
            opt1 = "#{"%2s" % i.to_s}) #{"%-#{max+2}s" % sorts[i]}"
            opt2 = ""
            if i+1 < sorts.size
                opt2 = "#{"%2s" % (i+1).to_s}) #{sorts[i+1]}"
            end
            options << "\t#{opt1}|  #{opt2}"
        end
        return options
    end


    @@OPTIONS = { data: create_data_options(), sort: create_sort_options() }
end
