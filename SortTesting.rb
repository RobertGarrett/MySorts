# Load all ruby files (except self) in current directory
Dir.children(".").each do |file|
    if file[-3..-1] == ".rb" && file[0...-3] != "SortTesting"
        require_relative file
    end
end

# These sorts function regardless of data input
comp_sorts = {
    Ruby => true,
    Quick => false,
    RandomQuick => true,
    Merge => true,
    Insertion => true,
    InPlaceInsertion => true
}


Timer.header(:random)
comp_sorts.each { |clazz, bool| clazz.time_all(:random) }
LSDRadix.time_all(:random)
MSDRadix.time_all(:random)

Timer.header(:sorted)
comp_sorts.each { |clazz, bool| clazz.time_all(:sorted, bool) }
LSDRadix.time_all(:sorted)
MSDRadix.time_all(:sorted)

Timer.header(:reversed)
comp_sorts.each { |clazz, bool| clazz.time_all(:reversed, bool) }
LSDRadix.time_all(:reversed)
MSDRadix.time_all(:reversed)

# Timer.header(:floats)
# comp_sorts.each { |clazz, bool| clazz.time_all(:floats) }
# LSDRadix.time_all(:floats)
# MSDRadix.time_all(:floats)

# Timer.header(:strings)
# comp_sorts.each { |clazz, bool| clazz.time_all(:strings) }
# StringRadix.time_all(:strings)
# InsertionStringRadix.time_all(:strings)


puts puts
