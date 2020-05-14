require_relative 'MergeSorts.rb'
require_relative 'QuickSorts.rb'
require_relative 'RadixSorts.rb'
require 'faker'


print "\n_____Random #{"_"*75}\n"
random = Array.new(100000) { rand(0...100000) }
Radix.time(random)
QuickSort.time(random)
RandomQuickSort.time(random)
ReferenceMergeSort.time(random)
MyMergeSort.time(random)

print "\n_____SORTED #{"_"*75}\n"
sorted = (1..10000).to_a
Radix.time(sorted)
QuickSort.time(sorted)
RandomQuickSort.time(sorted)
ReferenceMergeSort.time(sorted)
MyMergeSort.time(sorted)

print "\n_____Reversed #{"_"*75}\n"
reversed = sorted.reverse
Radix.time(reversed)
QuickSort.time(reversed)
RandomQuickSort.time(reversed)
ReferenceMergeSort.time(reversed)
MyMergeSort.time(reversed)

puts puts
