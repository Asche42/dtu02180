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
      res = clauses.flatten(1)
      a = res.clone
      a.each do |atom|
        res.reject!{|e| e == atom.not}
      end
      res
    end
  end
end
