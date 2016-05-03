# coding: utf-8
# Implementation of the A* pathfinding algorithm.

require 'pp'

require_relative 'data_structures'
require_relative 'pathfinding'
require_relative 'logic'

module Heureka
  module Pathfinding
    # Defines the A* functions and data structures for project Heureka.
    module Astar
      include ::Contracts

      # A Node is a basic abstract entity used for pathfinding purposes.
      # It is inherited by NodeGraph and NodeInferenceEngine.
      class Node < Vertex
        attr_accessor :g, :previous

        Contract Contracts::Num, Contracts::Num => Contracts::Any
        def initialize(x, y)
          super(x, y)
          @g = @h = Float::INFINITY
          @previous = nil
        end

        Contract Contracts::None => Contracts::Num
        def cost
          @h + @g
        end

        def compute_new_g(_neighbor)
          raise 'Method compute_new_g was not overloaded.'
        end

        def update_h(_destination)
          raise 'Method update_h was not overloaded.'
        end

        def update_neighbors
          raise 'Method update_neighbors was not overloaded.'
        end
      end

      # A NodeGraph inherits Node.
      # This data structure is used for pathfinding on graphs.
      class NodeGraph < Node
        Contract Node => Contracts::Any
        def update_h(destination)
          @h = euclidean_distance(destination)
        end

        Contract Node, Node => Contracts::Num
        def compute_new_g(neighbor)
          @g + euclidean_distance(neighbor)
        end

        Contract Node => Contracts::Num
        def euclidean_distance(vertex)
          # We use the euclidian distance as our heuristic
          #   for this A* implementation.
          Math.sqrt((@x - vertex.x)**2 + (@y - vertex.y)**2)
        end

        def update_neighbors; end
      end

      # A NodeInferenceEngine inherits Node.
      # This data structure is used for pathfinding on inference engine rules.
      class NodeInferenceEngine < Node
        attr_accessor :clause, :kb

        Contract Node => Contracts::Any
        def update_h(_destination)
          @h = @clause.size
        end

        Contract Node, Node => Contracts::Num
        def compute_new_g(_neighbor)
          @g + 1
        end

        def update_neighbors
          # TODO
        end
      end

      Contract Node => ArrayOf[Vertex]
      def self.build_path(node)
        path = []
        current_node = node

        until current_node.nil?
          path.unshift(current_node)
          current_node = current_node.previous
        end

        path
      end

      Contract ArrayOf[Node], Node, Node => Contracts::Any
      def self.process(origin, destination)
        origin.update_h(destination)
        origin.g = 0

        open_set = [origin]
        closed_set = []
        current_node = nil

        until open_set.empty?
          current_node = open_set.min
          break if current_node == destination

          open_set.delete(current_node)
          closed_set << current_node

          current_node.update_neighbors

          current_node.neighbors.each do |neighbor|
            next if closed_set.include?(neighbor)

            neighbor.update_h(destination)

            try_g_neighbor = current_node.compute_new_g(neighbor)
            if !open_set.include?(neighbor)
              open_set << neighbor
            elsif try_g_neighbor >= neighbor.g
              next
            end

            neighbor.previous = current_node
            neighbor.g = try_g_neighbor
            neighbor.update_h(destination)
          end
        end

        build_path(current_node)
      end
    end
  end
end
