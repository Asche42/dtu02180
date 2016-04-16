require_relative 'data_structures'
require_relative 'pathfinding'

module Heureka
  class Atom
    attr_reader :letter, :sign
    def initialize(letter, sign)
      @letter = letter
      @sign = sign
      
    end
    def hash()
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
  
  class Clause < Array
    def |(clause)
      res = self + clause
      res.uniq!
      a = res.clone
      a.each do |atom|
        res.reject!{|e| e == atom.not}
      end
      res
    end
    
    def h
      self.size
    end
  end
end

module Heureka
  clause0, clause1, clause2, clause3 = Clause.new, Clause.new, Clause.new, Clause.new
  clause0 << Atom.new(:a, true) << Atom.new(:c, true)
  clause1 << Atom.new(:b, true) << Atom.new(:c, false)
  clause2 << Atom.new(:b, false)
  clause3 << Atom.new(:c, true)
  lol = clause1 | clause2
  puts (lol.first.sign)
end

