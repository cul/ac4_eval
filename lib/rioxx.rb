# http://www.rioxx.net/schema/v2.0/rioxxterms/
module Rioxx
  class Terms < RDF::StrictVocabulary("http://www.rioxx.net/schema/v2.0/rioxxterms/")
    property :funder_id,
      type: ["xs:anyURI"].freeze,
      label: 'This SHOULD be a globally unique identifier for the funder of the resource.'.freeze
    property :funder_name,
      label: 'The canonical name of the entity responsible for funding the '\
             'resource SHOULD be recorded here as text.'.freeze
    property :project,
      label: 'This is designed to collect the project ID(s), issued by the '\
             'funder(s), that relate to the resource'.freeze
  end
end