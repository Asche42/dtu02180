#!/usr/bin/ruby
# coding: utf-8

require 'pp'

require_relative 'data_structures'
require_relative 'astar'

dataset, link_names = Heureka::Pathfinding.parse(open('manhattan.txt').read)

path = Heureka::Pathfinding::Astar.process(dataset, dataset.first, dataset[10])

path.each do |e|
  puts "(#{e.x}, #{e.y})"
end

