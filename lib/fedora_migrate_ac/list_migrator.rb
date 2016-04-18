module FedoraMigrate
  module AcademicCommons
    class ListMigrator < FedoraMigrate::AcademicCommons::ListProcessor
      def object_mover(source, target=nil)
        FedoraMigrate::AcademicCommons::ObjectMover.new(source, target, options)
      end

      def sparql_query(source)
        subject = source.uri
        predicate = MEMBER_OF.to_s
        FedoraMigrate::AcademicCommons.sparql_inbound(subject, predicate)
      end

      def migrate_relationship
        rels = FedoraMigrate::AcademicCommons::RelsExtDatastreamMover.new(source).migrate
        result.relationships = rels
        result.status = true
      rescue StandardError => e
        result.relationships = e.inspect
        result.status = false
      end
    end
  end
end
