# Load all ruby files (except self) in current directory
files = Dir.children("./Sorts")
files.each { |file| require_relative "./Sorts/#{file}" }
require_relative "./Util"



DATA_TYPES = [:random, :sorted, :reversed, :floats, :strings]

OPTIONS = ["0) All"]
DATA_TYPES.each_with_index.map do |type, idx|
    OPTIONS << "#{idx+1}) #{type.to_s.capitalize}"
end



def get_option
    puts "\nTesting Options:\n"
    OPTIONS.each { |opt| puts "     #{opt}" }
    print "Your Selection (-1 to exit): "
    return gets.chomp
end

def delegate(option)
    case option
    when 0; DATA_TYPES.each { |type| run_tests(type) }
        when 1,2,3,4,5; run_tests( DATA_TYPES[option-1] )
        else; puts "!--- Invalid Selection ---!"
    end
end

def run_tests(type)
    Timer.header(type)
    sorts = Util.config.reject { |k, v| v["data_exceptions"].include?(type.to_s) }
    sorts = sorts.keys.map { |sort| Object.const_get(sort) }
    sorts.each { |sort| sort.time_all }
end



exit = false
while !exit
    option = get_option()
    if Util.is_number?(option)
        break if option == "-1"
        delegate( Integer(option) )
    end
end
puts ""
