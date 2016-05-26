module FedoraMigrate
  module AcademicCommons
    class ModsPropertyMover < FedoraMigrate::RDFDatastreamMover
      DATE_SELECTOR = "mods>originInfo>dateIssued[@keyDate='yes']".freeze
      DOI_SELECTOR = "mods>identifier[@type='CDRS doi']".freeze
      FAMILY_NAME_PART_SELECTOR = "namePart[@type='family']".freeze
      GIVEN_NAME_PART_SELECTOR = "namePart[@type='given']".freeze
      HOST_ISSN_SELECTOR = "relatedItem[@type='host']>identifier[@type='issn']".freeze
      ISSN_SELECTOR = "relatedItem[@type='series']>identifier[@type='issn']".freeze
      LANGUAGE_SELECTOR = "language>languageTerm".freeze
      LOCATION_SELECTOR = "location>physicalLocation".freeze
      PERSONAL_NAME_SELECTOR = "mods>name[@type='personal']".freeze
      SUBJECT_SELECTOR = "mods>subject>topic".freeze
      TITLE_SELECTOR = "mods>titleInfo>title".freeze

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
        # AcademicCommons::Properties defines date_issued for DC11::issued
        # grab the top-level dateIssued, this is a single-valued property
        mods_xml.css(DATE_SELECTOR).each { |node| target.date_issued = w3cdtf(node) }

        # AcademicCommons::Properties defines doi for LC::doi
        # grab the top-level DOI identifiers for this single-value property
        mods_xml.css(DOI_SELECTOR).each { |node| target.doi = stripped_text(node) }

        # AcademicCommons::Properties defines format for DC11::format
        mods_xml.css("typeOfResource").each { |node| target.format = stripped_text(node) }

        # AcademicCommons::Properties defines location
        # mapped to DC11::spatial
        mods_xml.css(LOCATION_SELECTOR).each { |node| target.location = stripped_text(node) }

        migrate_multiple_value_properties
      end

      def migrate_multiple_value_properties
        # grab the top-level titles for this multiple-value property
        target.title = mods_xml.css(TITLE_SELECTOR).map { |node| stripped_text(node) }

        # CurationConcerns::BasicMetadata defines resource_type property
        # mapped to DC11::type
        target.resource_type = mods_xml.css("genre").map { |node| stripped_text(node) }

        # AcademicCommons::Properties defines issn
        # mapped to LC::issn
        target.issn = mods_xml.css(ISSN_SELECTOR).map { |node| stripped_text(node) }

        # CurationConcerns::BasicMetadata defines description text property
        # mapped to DC11::description
        target.description = mods_xml.css("abstract").map { |node| stripped_text(node) }

        # CurationConcerns::BasicMetadata defines multivalue language property
        # mapped to DC11::language
        target.language = mods_xml.css(LANGUAGE_SELECTOR).map { |node| stripped_text(node) }

        # CurationConcerns::BasicMetadata defines multivalue part_of property
        # mapped to DC11::isPartOf
        target.part_of = mods_xml.css(HOST_ISSN_SELECTOR).map { |node| stripped_text(node) }

        # CurationConcerns::BasicMetadata defines multivalue contributor property
        # mapped to DC11::contributor
        target.contributor = mods_xml.css(PERSONAL_NAME_SELECTOR).map { |node| name(node) }

        # CurationConcerns::BasicMetadata defines multivalue subject property
        # mapped to DC11::subject
        target.subject = mods_xml.css(SUBJECT_SELECTOR).map { |node| stripped_text(node) }
      end

      def text(node, selector = nil)
        selector ? node.css(selector).text : node.text
      end

      def stripped_text(node, selector = nil)
        text(node, selector).strip
      end

      def name(node)
        "#{text(node, FAMILY_NAME_PART_SELECTOR)}, #{text(node, GIVEN_NAME_PART_SELECTOR)}"
      end

      def w3cdtf(node, selector = nil)
        ModsPropertyMover.w3cdtf(stripped_text(node, selector))
      end
    end
  end
end
