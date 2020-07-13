# Load all ruby sort files
files = Dir.children("./Sorts")
files.each { |file| require_relative "./Sorts/#{file}" }
require_relative "./Util"
require_relative "./Config"


DATA_OPTIONS = Config.OPTIONS(:data)
SORT_OPTIONS = Config.OPTIONS(:sort)


def cli_loop()
    exit = false
    while !exit
        option = get_option()
        break if option == "-1"
        delegate( option )
    end
    puts ""
end

def get_option
    print "\nSort by type(t), class(c) or exit(-1)? "
    choice = gets.chomp
    return "-1" if choice == "-1"

    @options = choice == "t" ? DATA_OPTIONS : SORT_OPTIONS
    print_options()
    return gets.chomp
end

def print_options()
    #puts "Testing Options:\n"
    puts "#{"_"*50}\n\n"
    @options.each do |opt|
        puts "#{opt}"
    end
    print "#{"_"*50}\n\nYour Selection (-1 to exit): "
end

def delegate(option)
    if !Util.is_number?(option)
        puts "!--- Invalid Selection ---!"
        return
    end

    option = Integer(option)
    if @options == DATA_OPTIONS
        if option == 0
            Config.DATA_TYPES.each { |type| Timer.run(type) }
            return
        elsif option <= DATA_OPTIONS.length
            Timer.run( Config.DATA_TYPES[option-1] )
        else
            puts "!--- Invalid Selection ---!"
        end
    else
        Timer.run( Config.CONFIG["sort_order"][option-1] )
    end
end


cli_loop()
