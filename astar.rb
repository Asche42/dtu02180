# coding: utf-8
# Implementation of the A* pathfinding algorithm.

require 'pp'

require_relative 'data_structures'
require_relative 'pathfinding'
require_relative 'logic'

module Heureka
  module Pathfinding
    module Astar
      include ::Contracts

      class Node < Vertex
        attr_accessor :g, :previous

        def initialize
          super
          @g = @h = Float::INFINITY
          @previous = nil
        end

        Contract None => Num
        def cost
          @h + @g
        end

        def compute_new_g(neighbor); raise "Method compute_new_g was not overloaded."; end
        def update_h(destination); raise "Method update_h was not overloaded."; end
        def update_neighbors; raise "Method update_neighbors was not overloaded"; end
      end

      class NodeGraph < Node
        attr_accessor :x, :y

        def initialize(x, y)
          super()
          @x = x
          @y = y
        end

        Contract None => Fixnum
        def hash
          [@x, @y].hash
        end

        Contract Node => Any
        def update_h(destination)
          @h = euclidean_distance(destination)
        end

        Contract Node, Node => Num
        def compute_new_g(neighbor)
          @g + euclidean_distance(neighbor)
        end

        Contract Node => Num
        def euclidean_distance(vertex)
          # We use the euclidian distance as our heuristic for this A* implementation.
          Math.sqrt((@x - vertex.x)**2 + (@y - vertex.y)**2)
        end

        def update_neighbors; end
      end

      class NodeInferenceEngine < Node
        attr_accessor :clause, :kb

        def initialize(clause = nil, kb = nil)
          super()
          @clause = clause
          @kb = kb
        end

        Contract Node => Any
        def update_h(destination)
          @h = @clause.size
        end

        Contract Node, Node => Num
        def compute_new_g(neighbor)
          @g + 1
        end

        Contract None => Any
        def update_neighbors
          kb.each do |c|
            new_neighbor = NodeInferenceEngine.new
            new_neighbor.clause = Heureka::Clause.merge([clause, c])
            new_neighbor.kb = Set.new(kb.map { |e| Heureka::Clause.merge([e, clause]) })
            @neighbors << new_neighbor
          end
        end

        Contract NodeInferenceEngine => Bool
        def eql?(other)
          self == other
        end

        Contract NodeInferenceEngine => Bool
        def ==(other)
          return true if clause.empty? && other.clause.empty?
          clause == other.clause && kb == other.kb
        end

        Contract None => String
        def to_s
          clause.to_s
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

      Contract ArrayOf[Node], Node, Node => Any
      def self.process(dataset, origin, destination)
        # So, we're supposed to work with Nodes in the A* part of the project

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
            if not open_set.include?(neighbor)
              open_set << neighbor
            elsif try_g_neighbor >= neighbor.g
              next
            end

            neighbor.previous = current_node
            neighbor.g = try_g_neighbor
            neighbor.update_h(destination)
          end
        end

        self.build_path(current_node)
      end
    end
  end
end

