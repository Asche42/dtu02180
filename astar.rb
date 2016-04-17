# coding: utf-8
# Implementation of the A* pathfinding algorithm.

require 'pp'

require_relative 'data_structures'
require_relative 'pathfinding'

module Heureka
  module Pathfinding
    module Astar
      include ::Contracts

      class Node < Vertex
        attr_reader :previous, :g

        Contract Contracts::Num, Contracts::Num => Contracts::Any
        def initialize(x, y, destination = nil)
          super(x, y)
          @h = @g = 0
          @previous = nil
          @h = euclidean_distance(destination) if destination
        end

        Contract Vertex => Contracts::Any
        def initialize(vertex)
          super(vertex.x, vertex.y)
          @neighbors = vertex.neighbors
        end

        Contract Contracts::None => Contracts::Num
        def cost
          @h + @g
        end

        private

        Contract Vertex => Contracts::Num
        def euclidean_distance(vertex)
          # We use the euclidian distance as our heuristic for this A* implementation.
          Math.sqrt((x - vertex.x)**2 + (y - vertex.y)**2)
        end
      end

      Contract ArrayOf[Vertex], Vertex, Vertex => Contracts::Any
      def self.process(dataset, origin, destination)
        unless dataset.first.is_a?(Node)
          dataset.map! do |vertex|
            Node.new(vertex)
          end
        end

        origin = Node.new(origin) unless origin.is_a?(Node)
        destination = Node.new(destination) unless destination.is_a?(Node)

        open_set = [origin]
        closed_set = []
        current_node = nil


      end
    end
  end
end

