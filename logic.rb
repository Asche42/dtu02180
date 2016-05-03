# coding: utf-8

require_relative 'data_structures'
require_relative 'pathfinding'

module Heureka
  # An Atom is a basic logical structure.
  class Atom
    attr_reader :letter, :sign

    def initialize(letter, sign = true)
      @letter = letter
      @sign = sign
    end

    def hash
      [@letter, @sign].hash
    end

    def eql?(other)
      other.hash == hash
    end

    def ==(other)
      eql?(other)
    end

    def not
      Atom.new(@letter, !@sign)
    end

    def to_s
      (@sign ? @letter.to_s : 'not ' + @letter.to_s)
    end
  end

  # A Clause is an array of Atom.
  class Clause < Array
    def self.merge(clauses)
      res = clauses.flatten(1)
      res.uniq!
      a = res.clone
      a.each do |atom|
        res.reject! { |e| e == atom.not }
      end
      res
    end

    def h
      size
    end
  end
end
