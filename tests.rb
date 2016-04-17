# coding: utf-8

require 'rspec'
require 'pp'

require_relative 'data_structures'
require_relative 'pathfinding'
require_relative 'astar'

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

RSpec.describe Heureka::Pathfinding do
  before(:example) do
    @file_content = <<FILECONTENT
0 0 test0 1 1
1 1 test0 0 0
1 1 test1 2 2
2 2 test1 1 1
FILECONTENT
  end

  it 'should be able to correctly detect link names' do
    dataset, link_names = Heureka::Pathfinding.parse(@file_content)
    v0 = Heureka::Vertex.new(0.0, 0.0)
    v1 = Heureka::Vertex.new(1.0, 1.0)
    v2 = Heureka::Vertex.new(2.0, 2.0)

    expect(link_names.keys).to eq(["test0", "test1"])
    expect(link_names["test0"]).to eq([v0, v1])
    expect(link_names["test1"]).to eq([v1, v2])
  end

  it 'should be able to correctly producte a mesh from some file content' do
    dataset, link_names = Heureka::Pathfinding.parse(@file_content)
    v0 = Heureka::Vertex.new(0.0, 0.0)
    v1 = Heureka::Vertex.new(1.0, 1.0)
    v2 = Heureka::Vertex.new(2.0, 2.0)

    expect(dataset[0].neighbors).to eql([v1])
    expect(dataset[1].neighbors).to eql([v0, v2])
    expect(dataset[2].neighbors).to eql([v1])
  end

  it 'should be able to correctly perform a A* on a known dataset' do
    dataset, link_names = Heureka::Pathfinding.parse(@file_content)
    path = Heureka::Pathfinding::Astar.process(dataset, dataset.first, dataset.last)

    expect(path.first.x).to eq(0)
    expect(path.last.x).to eq(2)
  end
end
