require_relative 'MergeSorts.rb'
require_relative 'QuickSorts.rb'
require_relative 'RadixSorts.rb'
require_relative 'InsertionSorts.rb'
require 'faker'


print "\n_____Random #{"_"*75}\n"
random = Array.new(1000000) { rand(0...100000) }
Radix.time(random)
QuickSort.time(random)
RandomQuickSort.time(random)
ReferenceMergeSort.time(random)
MyMergeSort.time(random)
InsertionSort.time(random)
#InPlaceInsertionSort.time(random)

print "\n_____SORTED #{"_"*75}\n"
sorted = (1..1000).to_a
Radix.time(sorted)
QuickSort.time(sorted)
RandomQuickSort.time(sorted)
ReferenceMergeSort.time(sorted)
MyMergeSort.time(sorted)
InsertionSort.time(sorted)
#InPlaceInsertionSort.time(sorted)

print "\n_____Reversed #{"_"*75}\n"
reversed = sorted.reverse
Radix.time(reversed)
QuickSort.time(reversed)
RandomQuickSort.time(reversed)
ReferenceMergeSort.time(reversed)
MyMergeSort.time(reversed)
InsertionSort.time(reversed)
#InPlaceInsertionSort.time(reversed)

print "\n_____String Array #{"_"*75}\n"
strings = Array.new(100000){ Faker::Hipster.sentence }
QuickSort.time(strings)
RandomQuickSort.time(strings)
ReferenceMergeSort.time(strings)
MyMergeSort.time(strings)
InsertionSort.time(strings)
#InPlaceInsertionSort.time(strings)

puts puts
