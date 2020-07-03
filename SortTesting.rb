# Load all ruby sort files
files = Dir.children("./Sorts")
files.each { |file| require_relative "./Sorts/#{file}" }
require_relative "./Util"


DATA_OPTIONS = ["0) All"]
Util.DATA_TYPES.each_with_index do |type, idx|
    DATA_OPTIONS << "#{idx+1}) #{type.to_s.capitalize}"
end

SORT_OPTIONS = []
Util.CONFIG["sort_order"].each_with_index do |sort, idx|
    SORT_OPTIONS << "#{idx}) #{sort}"
end

@options = nil


def get_option
    print "\nSort by type(t), class(c)? "
    @options = gets.chomp == "t" ? DATA_OPTIONS : SORT_OPTIONS
    puts "Testing Options:\n"
    puts "______________________________\n\n"
    @options.each { |opt| puts "\t#{opt}" }
    puts "______________________________"
    print "\nYour Selection (-1 to exit): "
    return gets.chomp
end

def handle_option
    response = gets.chomp

end

def delegate(option)
    if !Util.is_number?(option)
        puts "!--- Invalid Selection ---!"
        return
    end

    option = Integer(option)
    if @options == DATA_OPTIONS
        if option == 0
            Util.DATA_TYPES.each { |type| Timer.run(type) }
            return
        elsif option <= DATA_OPTIONS.length
            Timer.run( Util.DATA_TYPES[option-1] )
        else
            puts "!--- Invalid Selection ---!"
        end
    else
        Timer.run( Util.CONFIG["sort_order"][option] )
    end
end

exit = false
while !exit
    option = get_option()
    break if option == "-1"
    delegate( option )
end
puts ""
