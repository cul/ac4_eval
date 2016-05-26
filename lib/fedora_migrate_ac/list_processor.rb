module FedoraMigrate
  module AcademicCommons
    class ListProcessor < FedoraMigrate::RepositoryMigrator
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
        mover = object_mover(source, nil)
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

      def object_mover(_source, _target = nil)
        raise "Unimplemented: override object_mover in a subclass"
      end
    end
  end
end
