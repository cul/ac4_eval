module FedoraMigrate
  module AcademicCommons
    class DescMetadataMover < FedoraMigrate::DatastreamMover
      def self.sparql_query(source)
        # take source object's uri
        subject = source.uri
        predicate = METADATA_FOR.to_s
        FedoraMigrate::AcademicCommons.sparql_inbound(subject, predicate)
      end

      # use rubydora's ri query to get the object that is
      # $description <http://purl.oclc.org/NET/CUL/metadataFor> @source
      def self.source_for(object)
        enum = FedoraMigrate.source.connection.find_by_sparql sparql_query(object)
        obj = enum.first
        ds = obj.datastreams['CONTENT'] if obj.datastreams['CONTENT']
        ds unless ds.nil? || ds.new?
      end
    end
  end
end
