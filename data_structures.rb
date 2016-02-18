# coding: utf-8
# Data structures for DTU 02180 project.

require 'contracts'

class Vertex
  include Contracts

  attr_accessor :x, :y

  Contract Contracts::Num, Contracts::Num => Contracts::Any
  def initialize(x, y)
    @x = x
    @y = y
  end

  Contract Vertex => Bool
  def ==(vertex)
    @x == vertex.x and @y == vertex.y
  end
end

class Edge
  include Contracts

  attr_accessor :a, :b, :name

  Contract String, Vertex, Vertex => Contracts::Any
  def initialize(name, a, b)
    @a = a
    @b = b
    @name = name
  end

  Contract Edge => Or[Vertex, nil]
  def intersection(edge)
    return @a if @a == edge.a or @a == edge.b
    return @b if @b == edge.a or @b == edge.b
    return nil
  end
end
