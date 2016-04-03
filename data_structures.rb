# coding: utf-8
# Data structures for DTU 02180 project.

require 'contracts'

module Heureka
  class Vertex
    include ::Contracts

    attr_accessor :x, :y

    Contract Contracts::Num, Contracts::Num => Contracts::Any
    def initialize(x, y)
      @x = x
      @y = y
    end

    Contract Vertex => Bool
    def ==(vertex)
      vertex.hash == self.hash
    end

    def hash
      [@x, @y].hash
    end
  end

  class Edge
    include ::Contracts

    attr_accessor :a, :b, :name

    Contract String, Vertex, Vertex => Contracts::Any
    def initialize(name, a, b)
      @a = a
      @b = b
      @name = name
    end

    def to_s
      "#{@name} between (#{@a.x}, #{@a.y} and (#{@b.x}, #{@b.y}))"
    end
  end
end
