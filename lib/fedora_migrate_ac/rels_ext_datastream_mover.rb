module FedoraMigrate
  module AcademicCommons
    class RelsExtDatastreamMover < FedoraMigrate::RelsExtDatastreamMover
      IGNORE = [
        ActiveFedora::RDF::Fcrepo::Model.hasModel,
        FedoraMigrate::AcademicCommons::MEMBER_OF
      ].freeze

      delegate :statements, to: :graph

      def statement?(stmt)
        !IGNORE.include?(stmt.predicate)
      end

      def membership?(stmt)
        stmt.predicate == FedoraMigrate::AcademicCommons::MEMBER_OF
      end

      def migrate_statements
        statements.each do |statement|
          next if missing_object?(statement)
          migrate_membership(statement) if membership?(statement)
          migrate_statement(statement) if statement?(statement)
        end
      end

      def migrate_statement(statement)
        target.ldp_source.graph << triple
        report << triple(statement).join("--")
      end

      def migrate_membership(statement)
        aggregator = aggregator_object(statement)
        return unless aggregator
        aggregator.members << target
        aggregator.save!
        report << triple(statement).join("--")
      end

      def triple(stmt)
        [target.rdf_subject, migrate_predicate(stmt.predicate), migrate_object(stmt.object)]
      end

      def aggregator_object(statement)
        ActiveFedora::Base.find(id_component(statement.object))
      rescue
        nil
      end
    end
  end
end
