require_relative 'MergeSorts.rb'
require_relative 'QuickSorts.rb'
require_relative 'RadixSorts.rb'
require_relative 'InsertionSorts.rb'
require 'faker'


print "\n_____Random #{"_"*75}\n"
Radix.time_random
QuickSort.time_random
RandomQuickSort.time_random
MergeSort.time_random
InsertionSort.time_random
InPlaceInsertionSort.time_random

print "\n_____SORTED #{"_"*75}\n"
Radix.time_sorted
QuickSort.time_sorted
RandomQuickSort.time_sorted
MergeSort.time_sorted
InsertionSort.time_sorted
InPlaceInsertionSort.time_sorted

print "\n_____Reversed #{"_"*75}\n"
Radix.time_reversed
QuickSort.time_reversed
RandomQuickSort.time_reversed
MergeSort.time_reversed
InsertionSort.time_reversed
InPlaceInsertionSort.time_reversed

print "\n_____String Array #{"_"*75}\n"
strings = Array.new(10000){ Faker::Hipster.sentence }
QuickSort.time(strings)
RandomQuickSort.time(strings)
MergeSort.time(strings)
InsertionSort.time(strings)
InPlaceInsertionSort.time(strings)

puts puts
