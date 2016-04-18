require 'spec_helper'
# this test has a great deal of mocking
# pending https://github.com/projecthydra/active_fedora/issues/1060
describe FedoraMigrate::AcademicCommons::ModsPropertyMover, type: :unit do
  let(:subject_uri) { RDF::URI("info:fedora/test") }
  let(:ldp_graph) do
    graph = ActiveTriples::Resource.new
    graph.set_subject!(subject_uri)
    graph
  end
  let(:ldp_resource) do
    mock = double(ActiveFedora::LdpResource)
    allow(mock).to receive(:subject_uri).and_return(nil)
    allow(mock).to receive(:new?).and_return(true)
    allow(mock).to receive(:graph).and_return(ldp_graph)
    mock
  end
  let(:ldp_resource_service) do
    mock = double(ActiveFedora::LdpResourceService)
    allow(mock).to receive(:build).and_return(ldp_resource)
    mock
  end
  let(:fedora_connection) do
    mock = double(ActiveFedora::Fedora)
    allow(mock).to receive(:ldp_resource_service).and_return(ldp_resource_service)
    allow(mock).to receive(:host).and_return("localhost")
    allow(mock).to receive(:base_path).and_return("base_path")
    mock
  end
  let(:mods) { File.read('spec/fixtures/mods.xml') }
  let(:source) do
    source = double("Rubydora::Datastream")
    allow(source).to receive(:content).and_return(mods)
    source
  end
  let(:target) do
    target = stub_model(GenericWork)
  end
  let(:options) { Hash.new }
  before do
    ActiveFedora.instance_variable_set(:@fedora, fedora_connection)
  end
  subject { described_class.new(source, target, options) }
  it "assigns properties" do
    subject.migrate_rdf_triples
    expect(target.title).to eql(["Looping Genomes: Diagnostic Change and the Genetic Makeup of the Autism Population"])
    expect(target.date_issued).to eql(Date.new(2016))
  end
  it "parses w3cdtf" do
    dt = described_class.w3cdtf("2000")
    expect(dt.year).to eql(2000)
    expect(dt.month).to eql(1)
    expect(dt.day).to eql(1)
    dt = described_class.w3cdtf("2000-2")
    expect(dt.year).to eql(2000)
    expect(dt.month).to eql(2)
    expect(dt.day).to eql(1)
    dt = described_class.w3cdtf("2000-2-14")
    expect(dt.year).to eql(2000)
    expect(dt.month).to eql(2)
    expect(dt.day).to eql(14)
  end
end
