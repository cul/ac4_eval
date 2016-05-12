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
        target.title = [] if mods_xml.css("mods>titleInfo>title").first
        mods_xml.css("mods>titleInfo>title").each do |title|
          target.title << title.text.strip
        end
        # grab the top-level dateIssued, this is a single-valued property
        mods_xml.css("mods>originInfo>dateIssued[@keyDate='yes']").each do |date_issued|
          target.date_issued = ModsPropertyMover.w3cdtf(date_issued.text.strip)
        end
        # grab the top-level DOI identifiers for this multiple-value property
        target.identifier = []

        mods_xml.css("mods>identifier[@type='CDRS doi']").each do |identifier|
          target.doi = identifier.text.strip
        end

        target.issn = []
        mods_xml.css("relatedItem[@type='series']>identifier[@type='issn']").each do |issn|
          target.issn << issn.strip
        end

        mods_xml.css("abstract").each do |abstract|
          target.description = abstract.text.strip
        end

        mods_xml.css("language>languageTerm").each do |language|
          target.language = language.text.strip
        end

        mods_xml.css("typeOfResource").each do |format|
          target.format = format.text.strip
        end

        mods_xml.css("genre").each do |genre|
          target.genre = genre.text.strip
        end

        mods_xml.css("location>physicalLocation").each do |location|
          target.location = location.text.strip
        end

        mods_xml.css("relatedItem[@type='host']>identifier[@type='issn']").each do |part_of|
          target.part_of = part_of.text.strip
        end

        target.contributor = []
        mods_xml.css("mods>name[@type='personal']").each do |author|
          target.contributor << (author.css("namePart[@type='family']").text + ", " + author.css("namePart[@type='given']").text)
        end

        target.subject = []
        mods_xml.css("mods>subject>topic").each do |subject|
          target.subject << subject.text.strip
        end
      end
    end
  end
end
