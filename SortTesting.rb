require_relative 'Merge.rb'
require_relative 'Quick.rb'
require_relative 'LSDRadix.rb'
require_relative 'Insertion.rb'
require_relative 'MSDRadix.rb'
require_relative 'Hybrids.rb'
require 'faker'



print "\n\n_____Random #{"_"*75}\n\n"
LSDRadix.time_random
MSDRadix.time_random
QuickSort.time_random
RandomQuickSort.time_random
MergeSort.time_random
InsertionSort.time_random
InPlaceInsertionSort.time_random
#
#
#
# print "\n\n_____SORTED #{"_"*75}\n\n"
# Radix.time_sorted
# QuickSort.time_sorted
# RandomQuickSort.time_sorted
# MergeSort.time_sorted
# InsertionSort.time_sorted
# InPlaceInsertionSort.time_sorted
#
#
#
# print "\n\n_____Reversed #{"_"*75}\n\n"
# Radix.time_reversed
# QuickSort.time_reversed
# RandomQuickSort.time_reversed
# MergeSort.time_reversed
# InsertionSort.time_reversed
# InPlaceInsertionSort.time_reversed



strings = Array.new(100000){ Faker::Alphanumeric.alphanumeric(number: 10) }
max = strings.map(&:length).max
print "\n\n_____Short String Array ( MAX = #{max} )#{"_"*75}\n\n"

QuickSort.time(strings)
RandomQuickSort.time(strings)
MergeSort.time(strings)
InsertionSort.time(strings)
InPlaceInsertionSort.time(strings)
StringRadix.time(strings)
InsertionStringRadix.time(strings)


puts puts
