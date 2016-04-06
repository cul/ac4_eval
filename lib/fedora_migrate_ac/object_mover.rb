module FedoraMigrate
  module AcademicCommons
    class ObjectMover < FedoraMigrate::ObjectMover
      def post_initialize
        super
      end

      def before_object_migration
        target.apply_depositor_metadata('fedoraAdmin')
        target.read_groups = ["public"]
        target.title = [source.label || source.pid]
        target
      end

      def target
        @target ||= OverrideTargetConstructor.new(source).build
      end

      def migrate_content_datastreams
        save
        target.attached_files.keys.each do |ds|
          mover = mover_for(ds)
          if mover && !mover.source.new?
            report.content_datastreams << ContentDatastreamReport.new(ds, mover.migrate)
          end
        end
        migrate_legacy_content
      end

      def migrate_legacy_content
        source_ds = source.datastreams['CONTENT']
        return unless source_ds && !source_ds.new?
        target.original_file = target.build_original_file
        mover = FedoraMigrate::DatastreamMover.new(source_ds, target.original_file)
        save
        mover.migrate
      end

      def mover_for(ds)
        mover_class = FedoraMigrate::DatastreamMover
        case ds.to_s
        when 'descMetadata'
          source_ds = DescMetadataMover.source_for(source)
          mover_class = DescMetadataMover
        else
          source_ds = source.datastreams[ds.to_s]
        end
        mover_class.new(source_ds, target.attached_files[ds.to_s], options)
      end
    end
  end
end
