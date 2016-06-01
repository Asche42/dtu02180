# coding: utf-8
# Data structures for DTU 02180 project.

require 'contracts'

module Heureka
  class Vertex
    include ::Contracts

    attr_reader :neighbors

    Contract Num, Num => Any
    def initialize
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

    Contract Vertex => Num
    def cost(_vertex)
      raise 'Method cost was not overloaded.'
    end

    Contract Vertex => Num
    def <=>(other)
      # If the two nodes are at the same position, their cost is the same.
      return 0 if self == other
      cost <=> other.cost
    end

    Contract Vertex => Any
    def add(neighbor)
      # If this neighbor is not already present
      @neighbors << neighbor unless @neighbors.include?(neighbor)
    end
    alias << add
  end
end
