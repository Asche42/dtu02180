# coding: utf-8
# Pathfinding algorithms for DTU 02180 project

require 'contracts'

require_relative 'data_structures'

module Heureka
  class Pathfinding
    include ::Contracts

    Contract ArrayOf[Edge], Vertex, Vertex => Contracts::Any
    def initialize(edges, origin, destination)
      @edges = edges
      @origin = origin
      @destination = destination
    end

    Contract Vertex => Contracts::Num
    def cost(vertex)
      raise "Method cost was not overloaded."
    end
  end
end

