module FedoraMigrate
  module AcademicCommons
    class ListDescriber < FedoraMigrate::AcademicCommons::ListProcessor
      def object_mover(source, target=nil)
        FedoraMigrate::AcademicCommons::ObjectDescriber.new(source, target, options)
      end

      def migrate_relationship
      end

      def migration_required?
        return false if blacklist.include?(source.pid)
        true
      end
    end
  end
end
