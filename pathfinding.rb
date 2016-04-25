# coding: utf-8
#
# Implementation of the basic pathfinding input tools.

require_relative 'data_structures'
require_relative 'astar'

module Heureka
  module Pathfinding
    # Function to parse the file.
    # Won't work with UTF-8 street names.
    def self.parse(file_content)
      line_regex = /^([0-9.]+) ([0-9.]+) ([-A-Za-z0-9_ ]+) ([0-9.]+) ([0-9.]+)$/i
      dataset = []
      link_names = {}

      file_content.each_line do |line|
        if line =~ line_regex
          xa, ya, name, xb, yb = line.match(line_regex).captures

          v0 = Heureka::Pathfinding::Astar::Node.new(xa.to_f, ya.to_f)
          v0 = dataset.find {|e| e == v0 } || v0

          v1 = Heureka::Pathfinding::Astar::Node.new(xb.to_f, yb.to_f)
          v1 = dataset.find {|e| e == v1 } || v1

          v0 << v1

          dataset << v0
          dataset << v1
          dataset.uniq!

          # If the array does not already exist for this street name
          link_names[name] ||= []
          link_names[name] << v0
          link_names[name] << v1
          link_names[name].uniq!
        else
          STDERR.puts "Following line was not recognized: #{line}"
        end
      end

      [dataset, link_names]
    end
  end
end
