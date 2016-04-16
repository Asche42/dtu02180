# coding: utf-8

require 'rspec'

require_relative 'data_structures'

RSpec.describe Heureka::Vertex do
  it 'should correctly compare two vertices at the same place' do
    v0, v1 = Array.new(2, Heureka::Vertex.new(1, 1))
    expect(v0).to eq(v1)
  end

  it 'should be able to retrieve a vertex from a hashmap' do
    v0, v1 = Array.new(2, Heureka::Vertex.new(1, 1))
    h = Hash[v0, :test]
    expect(h[v1]).to eq(:test)
  end
end
