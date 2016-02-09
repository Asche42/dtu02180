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

pp read_file('pathfinding.txt')
