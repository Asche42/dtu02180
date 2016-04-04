# coding: utf-8

# Pretty Printing library
require 'pp'

require_relative 'data_structures'
require_relative 'pathfinding'

# Function to parse the file.
# Won't work with UTF-8 street names.
def read_file(filename)
  file_content = File.read(filename)
  line_regex = /^([0-9.]+) ([0-9.]+) ([-A-Za-z0-9_ ]+) ([0-9.]+) ([0-9.]+)$/i
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

# Function to read, parse and check user input.
def read_input(edges, street_names)
  loop do
    print "> "
    street_a, street_b = gets.split # Parse the input

    # The input is not correct.
    if street_a == street_b or not street_names.include?(street_a) or not street_names.include?(street_b)
      STDERR.puts "The input streets given are invalid."
      next # Let's give the user another shot...
    end

    # Let's find the intersection for the two streets
    street_a_intersections = Set.new(edges.select{|e| e.name == street_a}.reduce([]){|memo, e| memo << e.a << e.b})
    street_b_intersections = Set.new(edges.select{|e| e.name == street_b}.reduce([]){|memo, e| memo << e.a << e.b})
    input = (street_a_intersections & street_b_intersections).to_a.first

    # The two streets don't intersect.
    unless input
      STDERR.puts "No intersection was found."
      next
    end

    # An intersection was found, no need to cycle again.
    return [street_a, street_b, input]
  end
end



edges = read_file('manhattan.txt')

# Let's list all the street names.
street_names = edges.map(&:name).uniq
puts "The following streets were found:#{street_names.reduce(""){|memo, s| memo + " #{s}"}}"
puts

# Now we can ask for the starting point.
puts "Enter the two origin street names separated by a space:"
street_a, street_b, origin = read_input(edges, street_names)
puts "The chosen streets are: #{street_a} and #{street_b}, the destination point is at: (#{origin.x}, #{origin.y})."

# And then for the destination point.
puts
puts "Enter the two destination street names separated by a space:"
street_a, street_b, destination = read_input(edges, street_names)
puts "The chosen streets are: #{street_a} and #{street_b}, the destination point is at: (#{destination.x}, #{destination.y})."
