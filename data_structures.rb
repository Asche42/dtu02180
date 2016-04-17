# coding: utf-8
# Data structures for DTU 02180 project.

require 'contracts'

module Heureka
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
    def ==(vertex)
      vertex.hash == self.hash
    end

    # The two following methods are needed so that Array#uniq and Set#merge
    # work on Vertex objects.
    Contract Vertex => Bool
    def eql?(vertex)
      self == vertex
    end

    Contract Contracts::None => Fixnum
    def hash
      [@x, @y].hash
    end

    Contract Vertex => Contracts::Num
    def cost(vertex)
      raise "Method cost was not overloaded."
    end

    Contract Vertex => Contracts::Num
    def <=>(vertex)
      # If the two nodes are at the same position, their cost is the same.
      return 0 if self == vertex
      cost <=> vertex.cost
    end

    Contract Vertex => Contracts::Any
    def add(neighbor)
      # If this neighbor is not already present
      @neighbors << neighbor unless @neighbors.include?(neighbor)
    end
    alias_method :<<, :add
  end
end
