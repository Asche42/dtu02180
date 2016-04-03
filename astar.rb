require_relative 'data_structures'
require_relative 'pathfinding'

module Heureka
  class Node < Vertex
    include ::Contracts

    attr_accessor :previous

    Contract Contracts::Num, Contracts::Num => Contracts::Any
    def initialize(x, y)
      @x = x
      @y = y
      @h = @g = 0
      @previous = nil
    end
  end

  class Astar < Pathfinding
    include ::Contracts

    Contract ArrayOf[Edge], Vertex, Vertex => Contracts::Any
    def initialize(edges, origin, destination)
      super(edges, origin, destination)

      @open_set = [@origin]
      @closed_set = []
      @current_node = nil
    end

    Contract Vertex => Contracts::Num
    def h(vertex)
      # We use the euclidian distance as our heuristic for this A* implementation.
      Math.sqrt((@destination.x - vertex.x) ** 2 + (@destination.y - vertex.y) ** 2)
    end

    Contract Vertex => Contracts::Num
    def cost(vertex)
      # This path has not been explored yet.
      return nil unless @current_path.include?(vertex)
    end

    private

    Contract Contracts::None => Vertex
    def shortest_cost_candidate
      @open_set.
    end
  end
end
