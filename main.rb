#!/usr/bin/ruby
# coding: utf-8

require 'pp'

require_relative 'data_structures'
require_relative 'astar'
require_relative 'logic'

class Input
  def self.read(link_names)
    loop do
      print "> "
      street_a, street_b = gets.split # Parse the input

      # The input is not correct.
      if street_a == street_b or not link_names.keys.include?(street_a) or not link_names.keys.include?(street_b)
        STDERR.puts "The input streets given are invalid."
        next # Let's give the user another shot...
      end

      input = (Set.new(link_names[street_a]) & Set.new(link_names[street_b])).to_a.first

      # The two streets don't intersect.
      unless input
        STDERR.puts "No intersection was found."
        next
      end

      # An intersection was found, no need to cycle again.
      return [street_a, street_b, input]
    end
  end
end

module Heureka
  knowledge_base = []
  clause0, clause1, clause2 = Clause.new, Clause.new, Clause.new
  clause0 << Atom.new(:a) << Atom.new(:b, false)
  clause1 << Atom.new(:b) << Atom.new(:c, false)
  clause2 << Atom.new(:b) << Atom.new(:c)
  knowledge_base << clause0 << clause1 << clause2

  input = Clause.new
  input << Atom.new(:a)
  current = input.map{|e| e.not}
  until current.empty?
    current = Clause.merge([current, knowledge_base.sample])
    knowledge_base << current
    puts "zizi: #{current}"
  end
end

dataset, link_names = Heureka::Pathfinding.parse(open('manhattan.txt').read)

# Now we can ask for the starting point.
puts "Enter the two origin street names separated by a space:"
street_a, street_b, origin = Input.read(link_names)
puts "The chosen streets are: #{street_a} and #{street_b}, the origin point is at: (#{origin.x}, #{origin.y})."

# And then for the destination point.
puts
puts "Enter the two destination street names separated by a space:"
street_a, street_b, destination = Input.read(link_names)
puts "The chosen streets are: #{street_a} and #{street_b}, the destination point is at: (#{destination.x}, #{destination.y})."

path = Heureka::Pathfinding::Astar.process(dataset, origin, destination)

puts
puts "Full path is the following:"
path.each do |e|
  puts "(#{e.x}, #{e.y})"
end

