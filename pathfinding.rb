# coding: utf-8
#
# Implementation of the basic pathfinding input tools.

require_relative 'data_structures'
require_relative 'logic'
require_relative 'astar'

module Heureka
  module Pathfinding
    # Function to parse the file.
    # Won't work with UTF-8 street names.
    def self.parse_graph_file(file_content)
      line_regex = /^([0-9.]+) ([0-9.]+) ([-A-Za-z0-9_ ]+) ([0-9.]+) ([0-9.]+)$/i
      dataset = []
      link_names = {}

      file_content.each_line do |line|
        if line =~ line_regex
          xa, ya, name, xb, yb = line.match(line_regex).captures

          v0 = Heureka::Pathfinding::Astar::NodeGraph.new(xa.to_f, ya.to_f)
          v0 = dataset.find {|e| e == v0 } || v0

          v1 = Heureka::Pathfinding::Astar::NodeGraph.new(xb.to_f, yb.to_f)
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
        elsif line =~ /[ \t\n]/
        else
          STDERR.puts "Following line was not recognized: #{line}"
        end
      end

      [dataset, link_names]
    end

    def self.parse_inference_file(file_content)
      kb = Set.new
      origin = []

      file_content.each_line do |line|
        left, right = line.split(' if ').map(&:split)

        left = left.map { |e| Heureka::Atom.new(e.to_sym) }
        right = (right || []).map { |e| Heureka::Atom.new(e.to_sym, false) }

        left.each do |e|
          c = Clause.new([e] + right)
          kb << c
        end
      end

      file_content.split("\n").first.split(' if ').map(&:split).first.each do |e|
        origin << Heureka::Pathfinding::Astar::NodeInferenceEngine.new(Heureka::Clause.new([Heureka::Atom.new(e.to_sym).not]), kb)
      end

      [origin, kb]
    end
  end
end
