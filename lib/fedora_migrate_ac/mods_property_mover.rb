module FedoraMigrate
  module AcademicCommons
    class ModsPropertyMover < FedoraMigrate::RDFDatastreamMover
      W3CDTF = /(\d{4})(-(\d{1,2}))?(-(\d{1,2}))?/

      def self.w3cdtf(src)
        match = W3CDTF.match(src)
        if match
          parts = [match[1].to_i]
          parts << match[3].to_i if match[3]
          parts << match[5].to_i if match[5]
          Date.new(*parts)
        end
      end

      def mods_xml
        @mods_xml ||= Nokogiri::XML(source.content)
      end

      def migrate_rdf_triples
        # grab the top-level titles for this multiple-value property
        target.title = mods_xml.css("mods>titleInfo>title").map { |title| title.text.strip }

        # AcademicCommons::Properties defines date_issued for DC11::issued
        # grab the top-level dateIssued, this is a single-valued property
        mods_xml.css("mods>originInfo>dateIssued[@keyDate='yes']").each do |date_issued|
          target.date_issued = ModsPropertyMover.w3cdtf(date_issued.text.strip)
        end

        # AcademicCommons::Properties defines doi for LC::doi
        # grab the top-level DOI identifiers for this single-value property
        mods_xml.css("mods>identifier[@type='CDRS doi']").each do |identifier|
          target.doi = identifier.text.strip
        end

        # AcademicCommons::Properties defines issn for LC::issn
        target.issn = mods_xml.css("relatedItem[@type='series']>identifier[@type='issn']").map { |issn| issn.text.strip }

        # CurationConcerns::BasicMetadata defines description text property for DC11::description
        target.description =  mods_xml.css("abstract").map { |abstract| abstract.text.strip }

        # CurationConcerns::BasicMetadata defines multiple value language property for DC11::language
        target.language = mods_xml.css("language>languageTerm").map { |language| language.text.strip }

        # AcademicCommons::Properties defines format for DC11::format
        mods_xml.css("typeOfResource").each do |format|
          target.format = format.text.strip
        end

        # CurationConcerns::BasicMetadata defines resource_type property for DC11::type
        target.resource_type = mods_xml.css("genre").map { |genre| genre.text.strip }

        # AcademicCommons::Properties defines location for DC11::spatial
        mods_xml.css("location>physicalLocation").each do |location|
          target.location = location.text.strip
        end

        # CurationConcerns::BasicMetadata defines multiple value part_of property for DC11::isPartOf
        target.part_of = mods_xml.css("relatedItem[@type='host']>identifier[@type='issn']").map { |part_of| part_of.text.strip}

        # CurationConcerns::BasicMetadata defines multiple value contributor property for DC11::contributor
        target.contributor = mods_xml.css("mods>name[@type='personal']").map do |author|
          (author.css("namePart[@type='family']").text + ", " + author.css("namePart[@type='given']").text)
        end

        # CurationConcerns::BasicMetadata defines multiple value subject for property DC11::subject
        target.subject = mods_xml.css("mods>subject>topic").map { |subject| subject.text.strip }
      end
    end
  end
end
