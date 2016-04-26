#!/usr/bin/ruby
# coding: utf-8

require 'pp'

require_relative 'data_structures'
require_relative 'astar'

dataset, link_names = Heureka::Pathfinding.parse(open('manhattan.txt').read)

puts "Start: (#{dataset.first.x}, #{dataset.first.y})"
end_point = dataset.sample
puts "End: (#{end_point.x}, #{end_point.y})"

path = Heureka::Pathfinding::Astar.process(dataset, dataset.first, end_point)

path.each do |e|
  puts "(#{e.x}, #{e.y})"
end

