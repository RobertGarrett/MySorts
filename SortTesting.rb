# Load all ruby files (except self) in current directory
Dir.children("./Sorts").each do |file|
    if file[-3..-1] == ".rb" && file[0...-3] != "SortTesting"
        require_relative "./Sorts/#{file}"
    end
end

comp_sorts = [Ruby, Quick, RandomQuick, Merge, Insertion, InPlaceInsertion]


Timer.header(:random)
comp_sorts.each { |clazz| clazz.time_all(:random) }
BucketSort.time_all(:random)
LSDRadix.time_all(:random)
MSDRadix.time_all(:random)

Timer.header(:sorted)
comp_sorts.each { |clazz| clazz.time_all(:sorted) }
BucketSort.time_all(:sorted)
LSDRadix.time_all(:sorted)
MSDRadix.time_all(:sorted)

Timer.header(:reversed)
comp_sorts.each { |clazz| clazz.time_all(:reversed) }
BucketSort.time_all(:reversed)
LSDRadix.time_all(:reversed)
MSDRadix.time_all(:reversed)

Timer.header(:floats)
comp_sorts.each { |clazz| clazz.time_all(:floats) }
BucketSort.time_all(:floats)
LSDRadix.time_all(:floats)
MSDRadix.time_all(:floats)

Timer.header(:strings)
comp_sorts.each { |clazz, bool| clazz.time_all(:strings) }
StringRadix.time_all(:strings)
InsertionStringRadix.time_all(:strings)


puts puts
