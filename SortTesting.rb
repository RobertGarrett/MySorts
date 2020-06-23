# Load all ruby files (except self) in current directory
Dir.children("./Sorts").each do |file|
    if file[-3..-1] == ".rb" && file[0...-3] != "SortTesting"
        require_relative "./Sorts/#{file}"
    end
end
require_relative "./Util"



DATA_TYPES = [:random, :sorted, :reversed, :floats, :strings]

OPTIONS = DATA_TYPES.each_with_index.map do |type, idx|
    "#{idx+1}) #{type.to_s.capitalize}"
end
OPTIONS.insert(0, "0) All")

SORT_GROUPS = {
    numbers: [
        Ruby, Quick, RandomQuick, Merge, Insertion, Shell,
        InPlaceInsertion, Bucket, Pigeonhole, LSDRadix, MSDRadix
    ],
    strings: [
        Ruby, Quick, RandomQuick, Merge, Insertion, Shell,
        InPlaceInsertion, StringRadix, InsertionStringRadix
    ]
}
SORT_GROUPS.default = SORT_GROUPS[:numbers]

#Pigeonhole.sort(Util.make_array(100, :random))

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
    sorts = SORT_GROUPS[type]
    sorts = type == :strings ? SORT_GROUPS[:strings] : SORT_GROUPS[:default]
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
