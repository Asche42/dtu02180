# coding: utf-8

require 'pp'

require_relative 'data_structures'

def read_file(filename)
  file_content = File.read(filename)
  line_regex = /^([0-9.]+) ([0-9.]+) ([\p{L}\- ]+) ([0-9.]+) ([0-9.]+)$/i
  edges = []
  file_content.each_line do |line|
    if line =~ line_regex
      xa, ya, name, xb, yb = line.match(line_regex).captures
      edges << Edge.new(name, Vertex.new(xa.to_f, ya.to_f), Vertex.new(xb.to_f, yb.to_f))
    else
      STDERR.puts "Following line was not recognized: #{line}"
    end
  end
  edges
end

edges = read_file('pathfinding.txt')
puts "The following streets have been imported:"
edges.each_with_index do |edge, i|
  puts "  #{i}. #{edge.name}"
end

puts "Enter the two origin street numbers separated by a space:"
street_a = street_b = nil
loop do
  print "> "
  street_a, street_b = gets.split.map{ |e| edges[e.to_i] }
  break if street_a and street_b and street_a != street_b and street_a.intersection(street_b)
  puts "The input intersection was not found."
end
origin = street_a.intersection(street_b)
puts "The chosen streets are: #{street_a.name} and #{street_b.name}, the origin point is at: (#{point.x}, #{point.y})."

puts "Enter the two destination street numbers separated by a space:"
street_a = street_b = nil
loop do
  print "> "
  street_a, street_b = gets.split.map{ |e| edges[e.to_i] }
  break if street_a and street_b and street_a != street_b and street_a.intersection(street_b)
  puts "The input intersection was not found."
end
destination = street_a.intersection(street_b)
puts "The chosen streets are: #{street_a.name} and #{street_b.name}, the destination point is at: (#{point.x}, #{point.y})."
