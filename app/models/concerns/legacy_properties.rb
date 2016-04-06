module LegacyProperties
  extend ActiveSupport::Concern
  included do
    property :legacy_pid, predicate: ActiveFedora::RDF::Fcrepo::Model.PID, multiple: false do |ix|
      ix.as :stored_sortable
    end
    property :legacy_state, predicate: ActiveFedora::RDF::Fcrepo::Model.state, multiple: false do |ix|
      ix.as :stored_sortable
    end
  end
end
