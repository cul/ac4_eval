module FedoraMigrate
  module AcademicCommons
    class ObjectDescriber < FedoraMigrate::ObjectMover
      def post_initialize
        super
      end

      def before_object_migration
        target
      end

      def target
        @target ||= OverrideTargetConstructor.new(source).target.find(id_component)
      end

      def migrate
        prepare_target
        migrate_legacy_description
        complete_target
        super
      end

      def prepare_target
        report.class = target.class.to_s
        report.id = target.id
        before_object_description
      end

      def complete_target
        after_object_description
        save
      end

      def migrate_legacy_description
        source_ds = DescMetadataMover.source_for(source)
        return unless source_ds && !source_ds.new?
        mover = ModsPropertyMover.new(source_ds, target)
        mover.migrate
      end
    end
  end
end
