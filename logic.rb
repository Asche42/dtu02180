# coding: utf-8

require 'set'
require 'contracts'

require_relative 'data_structures'
require_relative 'pathfinding'

module Heureka
  class Atom
    include ::Contracts

    attr_reader :letter, :sign

    Contract Symbol, Bool => Contracts::Any
    def initialize(letter, sign = true)
      @letter = letter
      @sign = sign
    end

    Contract Contracts::None => Fixnum
    def hash
      [@letter, @sign].hash
    end

    Contract Atom => Contracts::Bool
    def eql?(other)
      other.hash == hash
    end

    Contract Atom => Contracts::Bool
    def ==(other)
      eql?(other)
    end
    
    Contract Contracts::None => Atom
    def not
      Atom.new(@letter, !@sign)
    end
    
    Contract Contracts::None => String
    def to_s
      (@sign ? @letter.to_s : "not " + @letter.to_s)
    end
  end
  
  class Clause < Set
    include ::Contracts

    Contract ArrayOf[Clause] => Clause
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

    Contract Contracts::Any => String
    def to_s
      reduce("") { |memo, e| memo + "#{e} " }
    end
  end
end
