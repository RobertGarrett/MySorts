Dir.children(".").each do |file|
    if file[0] != "."
        require_relative file
    end
end

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
# QuickSort.time_all(:sorted, false)

Timer.header(:reversed)
comp_sorts.each { |clazz, bool| clazz.time_all(:reversed, bool) }
LSDRadix.time_all(:reversed)
MSDRadix.time_all(:reversed)
# QuickSort.time_all(:reversed, false)

Timer.header(:floats)
comp_sorts.each { |clazz, bool| clazz.time_all(:floats) }
LSDRadix.time_all(:floats)
MSDRadix.time_all(:floats)
#QuickSort.time_all(:floats, false)

Timer.header(:strings)
comp_sorts.each { |clazz, bool| clazz.time_all(:strings) }
StringRadix.time_all(:strings)
InsertionStringRadix.time_all(:strings)


puts puts
