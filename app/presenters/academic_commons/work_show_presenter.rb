module AcademicCommons
  # This class is a work in progress, because we are not
  # necessarily meeting sufia's requirement that members
  # are always ordered
  class WorkShowPresenter < ::Sufia::WorkShowPresenter
    delegate :date_issued, :doi, :isbn, :issn, :description, :subject, :language, :resource_type, :contributor, :location, :part_of, to: :solr_document, allow_nil: true

    def file_set_presenters
      @file_set_presenters ||= member_presenters(file_set_ids.uniq)
    end

    def ordered_ids
      results = ActiveFedora::SolrService.query(
        "proxy_in_ssi:#{id}",
        fl: "ordered_targets_ssim")
      results.flat_map { |x| x.fetch("ordered_targets_ssim", []) }
    end

    # These are the file sets that belong to this work, but not necessarily
    # in order.
    def ordered_file_set_ids
      results = ActiveFedora::SolrService.query(
        "{!field f=has_model_ssim}FileSet",
        fl: "id",
        fq: "{!join from=ordered_targets_ssim to=id}id:\"#{id}/list_source\"")
      results.flat_map { |x| x.fetch("id", []) }
    end

    def file_set_ids
      results = ActiveFedora::SolrService.query(
        "{!field f=has_model_ssim}FileSet",
        fl: "id",
        fq: "{!join from=member_ids_ssim to=id}id:\"#{id}\"")
      results.flat_map { |x| x.fetch("id", []) }
    end
  end
end
