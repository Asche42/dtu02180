# coding: utf-8
# Data structures for DTU 02180 project.

require 'contracts'

module Heureka
  # A Vertex is a basic element of a graph.
  # Here, we define most of the most essential features used by
  # Heureka::Astar::Node.
  class Vertex
    include ::Contracts

    attr_accessor :x, :y
    attr_reader :neighbors

    Contract Contracts::Num, Contracts::Num => Contracts::Any
    def initialize(x, y)
      @x = x
      @y = y
      @neighbors = []
    end

    Contract Vertex => Bool
    def ==(other)
      other.hash == hash
    end

    # The two following methods are needed so that Array#uniq and Set#merge
    # work on Vertex objects.
    Contract Vertex => Bool
    def eql?(other)
      self == other
    end

    Contract Contracts::None => Fixnum
    def hash
      [@x, @y].hash
    end

    Contract Vertex => Contracts::Num
    def cost(_)
      raise 'Method cost was not overloaded.'
    end

    Contract Vertex => Contracts::Num
    def <=>(other)
      # If the two nodes are at the same position, their cost is the same.
      return 0 if self == other
      cost <=> other.cost
    end

    Contract Vertex => Contracts::Any
    def add(neighbor)
      # If this neighbor is not already present
      @neighbors << neighbor unless @neighbors.include?(neighbor)
    end
    alias << add
  end
end
