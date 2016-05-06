# coding: utf-8

require 'set'

require_relative 'data_structures'
require_relative 'pathfinding'

module Heureka
  class Atom
    attr_reader :letter, :sign

    def initialize(letter, sign = true)
      @letter = letter
      @sign = sign
    end

    def hash
      [@letter, @sign].hash
    end

    def eql?(atom)
      atom.hash ==  self.hash
    end

    def ==(atom)
      eql?(atom)
    end
    
    def not
      Atom.new(@letter, !@sign)
    end
    
    def to_s
      (@sign ? @letter.to_s : "not " + @letter.to_s)
    end
  end
  
  class Clause < Set
    def self.merge(clauses)
      res = Clause.new
      a = clauses.flatten(1)
      a.each { |clause| res |= clause }
      a = res.clone
      a.each do |atom0|
        a.each do |atom1|
          if atom0 == atom1.not || atom0.not == atom1
            res.reject! { |e| e == atom0 }
            res.reject! { |e| e == atom1 }
          end
        end
      end
      res
    end

    def to_s
      each do |e|
        print e
      end
      puts
    end
  end
end
