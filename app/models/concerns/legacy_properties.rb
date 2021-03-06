module LegacyProperties
  extend ActiveSupport::Concern
  included do
    ActiveFedora::RDF::Fcrepo::Model.tap do |fcrepo3|
      property :legacy_pid, predicate: fcrepo3.PID, multiple: false do |ix|
        ix.as :stored_sortable
      end
      property :legacy_state, predicate: fcrepo3.state, multiple: false do |ix|
        ix.as :stored_sortable
      end
    end
  end
end
