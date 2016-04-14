module FedoraMigrate
  module AcademicCommons
    class OverrideTargetConstructor < FedoraMigrate::TargetConstructor
      def target
        @target ||= map_target
        super
      end

      def map_target
        Array(candidates).map do |model|
          if model.to_s == "info:fedora/ldpd:ContentAggregator"
            GenericWork
          elsif model.to_s == "info:fedora/ldpd:Resource"
            FileSet
          end
        end.compact.first
      end
    end
  end
end
