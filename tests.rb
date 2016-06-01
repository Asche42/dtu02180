# coding: utf-8

require 'rspec'
require 'pp'

require_relative 'data_structures'
require_relative 'pathfinding'
require_relative 'astar'

RSpec.describe Heureka::Vertex do
  it 'should correctly compare two vertices at the same place' do
    v0, v1 = Array.new(2, Heureka::Pathfinding::Astar::NodeGraph.new(1, 1))
    expect(v0).to eq(v1)
  end

  it 'should be able to retrieve a vertex from a hashmap' do
    v0, v1 = Array.new(2, Heureka::Pathfinding::Astar::NodeGraph.new(1, 1))
    h = Hash[v0, :test]
    expect(h[v1]).to eq(:test)
  end
end

RSpec.describe Heureka::Pathfinding do
  before(:example) do
    @graph_file_content = <<FILECONTENT
0 0 test0 1 1
1 1 test0 0 0
1 1 test1 2 2
2 2 test1 1 1
FILECONTENT

    @inference_file_content = <<FILECONTENT
a b if c
c if d g
d
g
FILECONTENT
  end

  it 'should be able to correctly detect link names' do
    _dataset, link_names = Heureka::Pathfinding.parse_graph_file(@graph_file_content)
    v0 = Heureka::Pathfinding::Astar::NodeGraph.new(0.0, 0.0)
    v1 = Heureka::Pathfinding::Astar::NodeGraph.new(1.0, 1.0)
    v2 = Heureka::Pathfinding::Astar::NodeGraph.new(2.0, 2.0)

    expect(link_names.keys).to eq(%w(test0 test1))
    expect(link_names['test0']).to eq([v0, v1])
    expect(link_names['test1']).to eq([v1, v2])
  end

  it 'should be able to correctly producte a mesh from some file content' do
    dataset, _link_names = Heureka::Pathfinding.parse_graph_file(@graph_file_content)
    v0 = Heureka::Pathfinding::Astar::NodeGraph.new(0.0, 0.0)
    v1 = Heureka::Pathfinding::Astar::NodeGraph.new(1.0, 1.0)
    v2 = Heureka::Pathfinding::Astar::NodeGraph.new(2.0, 2.0)

    expect(dataset[0].neighbors).to eql([v1])
    expect(dataset[1].neighbors).to eql([v0, v2])
    expect(dataset[2].neighbors).to eql([v1])
  end

  it 'should be able to find the path when there is only one node' do
    v = Heureka::Pathfinding::Astar::NodeGraph.new(0.0, 0.0)
    path = Heureka::Pathfinding::Astar.process([v], v, v)

    expect(path.first).to eq(v)
  end

  it 'should be able to correctly perform a A* on a known dataset' do
    dataset, _link_names = Heureka::Pathfinding.parse_graph_file(@graph_file_content)
    path = Heureka::Pathfinding::Astar.process(dataset, dataset.first, dataset.last)

    expect(path.first.x).to eq(0)
    expect(path.last.x).to eq(2)
  end

  it 'should be able to parse an inference engine file' do
    origin, kb = Heureka::Pathfinding.parse_inference_file(@inference_file_content)

    expected_kb = Set.new
    expected_kb << Heureka::Clause.new([Heureka::Atom.new(:a),
                                        Heureka::Atom.new(:c, false)])
    expected_kb << Heureka::Clause.new([Heureka::Atom.new(:b),
                                        Heureka::Atom.new(:c, false)])
    expected_kb << Heureka::Clause.new([Heureka::Atom.new(:c),
                                        Heureka::Atom.new(:d, false),
                                        Heureka::Atom.new(:g, false)])
    expected_kb << Heureka::Clause.new([Heureka::Atom.new(:d)])
    expected_kb << Heureka::Clause.new([Heureka::Atom.new(:g)])

    expect(kb).to eq(expected_kb)
    expect(origin[0]).to eq(Heureka::Pathfinding::Astar::NodeInferenceEngine.new(Heureka::Clause.new([Heureka::Atom.new(:a, false)]), kb))
    expect(origin[1]).to eq(Heureka::Pathfinding::Astar::NodeInferenceEngine.new(Heureka::Clause.new([Heureka::Atom.new(:b, false)]), kb))
  end
end
