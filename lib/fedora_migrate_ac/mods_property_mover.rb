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
        mods_xml.css("mods>originInfo>dateIssued[@encoding='w3cdtf']").each do |dateIssued|
          target.date_issued = ModsPropertyMover.w3cdtf(dateIssued.text.strip)
        end
        # grab the top-level DOI identifiers for this multiple-value property
        target.identifier = []
        mods_xml.css("mods>identifier[@type='CDRS doi']").each do |identifier|
          target.identifier = [identifier.text.strip]
        end
      end
    end
  end
end

