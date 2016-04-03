# coding: utf-8

require 'pp'

require_relative 'data_structures'
require_relative 'pathfinding'

def read_file(filename)
  file_content = File.read(filename)
  line_regex = /^([0-9.]+) ([0-9.]+) ([-A-Za-z0-9_ ]+) ([0-9.]+) ([0-9.]+)$/i
  #line_regex = /^([0-9.]+) ([0-9.]+) ([\p{L}\- ]+) ([0-9.]+) ([0-9.]+)$/i
  edges = []
  file_content.each_line do |line|
    if line =~ line_regex
      xa, ya, name, xb, yb = line.match(line_regex).captures
      edges << Heureka::Edge.new(name, Heureka::Vertex.new(xa.to_f, ya.to_f), Heureka::Vertex.new(xb.to_f, yb.to_f))
    else
      STDERR.puts "Following line was not recognized: #{line}"
    end
  end
  edges
end

edges = read_file('manhattan.txt')

street_names = edges.map(&:name).uniq
puts "The following streets were found:#{street_names.reduce(""){|memo, s| memo + " #{s}"}}"

puts "Enter the two origin street names separated by a space:"
street_a = street_b = nil
loop do
  print "> "
  street_a, street_b = gets.split
  break if street_a != street_b and street_names.include?(street_a) and street_names.include?(street_b)
  puts "The input intersection was not found."
end
street_a_intersections = Set.new(edges.select{|e| e.name == street_a}.reduce([]){|memo, e| memo << e.a << e.b})
street_b_intersections = Set.new(edges.select{|e| e.name == street_b}.reduce([]){|memo, e| memo << e.a << e.b})
origin = (street_a_intersections & street_b_intersections).to_a.first
pp street_a_intersections
puts "The chosen streets are: #{street_a} and #{street_b}, the origin point is at: (#{origin.x}, #{origin.y})."

puts
puts "Enter the two destination street names separated by a space:"
street_a = street_b = nil
loop do
  print "> "
  street_a, street_b = gets.split.map{ |e| edges[e.to_i] }
  break if street_a and street_b and street_a != street_b and street_a.intersection(street_b)
  puts "The input intersection was not found."
end
destination = street_a.intersection(street_b)
puts "The chosen streets are: #{street_a.name} and #{street_b.name}, the destination point is at: (#{destination.x}, #{destination.y})."
