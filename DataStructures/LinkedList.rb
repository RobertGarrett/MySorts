# Fetched from 'https://www.rubyguides.com/2017/08/ruby-linked-list/'

class Node
    attr_accessor :next, :prev
    attr_reader   :value
    def initialize(value)
        @value = value
        @next  = nil
        @prev = nil
    end
    def to_s
        "Node with value: #{@value}"
    end
end

class LinkedList
    def initialize
        @head = nil
        @tail = nil
    end

    def append(value)
        if @head
            @tail.next = Node.new(value)
            @tail = @tail.next
        else
            @head = @tail = Node.new(value)
        end
    end
    def find_tail
        return @tail
    end
    def append_after(target, value)
        node = find(target)
        return unless node

        old_next = node.next
        node.next = Node.new(value)
        node.next.next = old_next
    end
    def find(value)
        return false if !node.next
        while true
            return node if node.value == value
            node = node.next
        end
    end
    def delete(value)
        if @head.value == value
            @head = @head.next
            return
        end
        node      = find_before(value)
        node.next = node.next.next
    end
    def find_before(value)
        node = @head
        return false if !node.next
        return node  if node.next.value == value
        while (node = node.next)
            return node if node.next && node.next.value == value
        end
    end
    def print
        node = @head
        puts node
        while (node = node.next)
            puts node
        end
    end
end
