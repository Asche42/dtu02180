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

origin, kb = Heureka::Pathfinding.parse_inference_file(open('clauses.txt').read)
destination = Heureka::Pathfinding::Astar::NodeInferenceEngine.new(Heureka::Clause.new([]), nil)

puts "We have #{origin.size} origin points."
puts

origin.each do |o|
  puts "Origin : #{o}"
  inference_engine_path = Heureka::Pathfinding::Astar.process([], o, destination)
  puts (inference_engine_path || "No path has been found.")
end

dataset, link_names = Heureka::Pathfinding.parse_graph_file(open('manhattan.txt').read)

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

