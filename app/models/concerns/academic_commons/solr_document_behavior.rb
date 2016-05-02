module AcademicCommons
  module SolrDocumentBehavior

    def date_issued
      date_field('date_issued')
    end

    def doi
      self[Solrizer.solr_name('doi', :stored_sortable)]
    end

    def isbn
      self[Solrizer.solr_name('isbn')]
    end

    def issn
      self[Solrizer.solr_name('issn')]
    end
  end
end
