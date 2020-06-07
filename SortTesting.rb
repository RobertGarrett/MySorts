require_relative 'Merge.rb'
require_relative 'Quick.rb'
require_relative 'LSDRadix.rb'
require_relative 'Insertion.rb'
require_relative 'MSDRadix.rb'
require_relative 'Hybrids.rb'

comp_sorts = {
    QuickSort => false,
    RandomQuickSort => true,
    MergeSort => true,
    InsertionSort => true,
    InPlaceInsertionSort => true
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
