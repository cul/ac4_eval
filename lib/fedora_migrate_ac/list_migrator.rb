module FedoraMigrate
  module AcademicCommons
    class ListMigrator < FedoraMigrate::RepositoryMigrator
      def source_objects
        # read off a list of PIDs
        list = options[:list] ? File.foreach(options[:list]).lazy.map(&:chomp) : []
        list.map do |id|
          begin
            FedoraMigrate.source.connection.find(id)
          rescue
            nil
          end
        end
      end

      def migrate_object
        mover = FedoraMigrate::AcademicCommons::ObjectMover.new(source, nil, options)
        result.object = mover.migrate
        result.status = true
        mover.target
      rescue StandardError => e
        result.object = e.inspect
        result.status = false
        nil
      ensure
        report.save(source.pid, result)
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
