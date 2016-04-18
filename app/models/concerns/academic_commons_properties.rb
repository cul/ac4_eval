require 'rioxx'
module AcademicCommonsProperties
  extend ActiveSupport::Concern
  included do
    RDF::Vocab::Identifiers.tap do |loc|
      property :doi, predicate: loc.doi, multiple: false do |ix|
        ix.as :stored_sortable
      end
      property :isbn, predicate: loc.isbn do |ix|
        ix.as :stored_searchable
      end
      property :issn, predicate: loc.issn do |ix|
        ix.as :stored_searchable
      end
    end
    property :date_issued, predicate: ::RDF::DC.issued, multiple: false do |ix|
      ix.type :date
      ix.as :stored_sortable
    end
    property :rioxx_funder_id, predicate: Rioxx::Terms.funder_id, multiple: false do |ix|
      ix.as :stored_sortable
    end
    property :rioxx_funder_name, predicate: Rioxx::Terms.funder_name do |ix|
      ix.as :stored_searchable
    end
    property :rioxx_project, predicate: Rioxx::Terms.project, multiple: false do |ix|
      ix.as :stored_sortable
    end
  end
end
