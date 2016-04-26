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
        attr_accessor :g, :previous

        Contract Contracts::Num, Contracts::Num => Contracts::Any
        def initialize(x, y)
          super(x, y)
          @g = @h = Float::INFINITY
          @previous = nil
        end

        Contract Vertex, Vertex => Contracts::Any
        def initialize(vertex)
          super(vertex.x, vertex.y)
          @neighbors = vertex.neighbors
          @g = @h = Float::INFINITY
          @previous = nil
        end

        Contract Contracts::None => Contracts::Num
        def cost
          @h + @g
        end

        Contract Node => Contracts::Any
        def update_h(destination)
          @h = euclidean_distance(destination)
        end

        Contract Vertex => Contracts::Num
        def euclidean_distance(vertex)
          # We use the euclidian distance as our heuristic for this A* implementation.
          Math.sqrt((x - vertex.x)**2 + (y - vertex.y)**2)
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

      Contract ArrayOf[Vertex], Vertex, Vertex => Contracts::Any
      def self.process(dataset, origin, destination)
        # So, we're supposed to work with Nodes in the A* part of the project
        origin = Node.new(origin) unless origin.is_a?(Node)
        destination = Node.new(destination) unless destination.is_a?(Node)

        origin.update_h(destination)
        origin.g = 0

        unless dataset.first.is_a?(Node)
          dataset.map! do |vertex|
            Node.new(vertex)
          end
        end

        open_set = [origin]
        closed_set = []
        current_node = nil

        until open_set.empty?
          current_node = open_set.min
          puts "Nœud actuel : #{current_node.x}, #{current_node.y}"
          break if current_node == destination

          open_set.delete(current_node)
          closed_set << current_node

          current_node.neighbors.each do |neighbor|
            next if closed_set.include?(neighbor)

            try_g_neighbor = current_node.g + current_node.euclidean_distance(neighbor)
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

