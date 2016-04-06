require 'active_fedora/cleaner'
require 'fedora-migrate'
require 'fedora_migrate_ac'
module FedoraMigrate::Hooks

  # @source is a Rubydora object
  # @target is a Hydra 9 modeled object

  # Called from FedoraMigrate::ObjectMover
  def before_object_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::ObjectMover
  def after_object_migration
    # additional actions as needed
    if source.state
      case source.state
      when 'D'
        target.legacy_state = ActiveFedora::RDF::Fcrepo::Model.Deleted.to_s
      when 'I'
        target.legacy_state = ActiveFedora::RDF::Fcrepo::Model.Inactive.to_s
      else
        target.legacy_state = ActiveFedora::RDF::Fcrepo::Model.Active.to_s
      end
    end
    target.legacy_pid = source.pid
  end

  # Called from FedoraMigrate::RDFDatastreamMover
  def before_rdf_datastream_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::RDFDatastreamMover
  def after_rdf_datastream_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::DatastreamMover
  def before_datastream_migration
    # additional actions as needed
  end

  # Called from FedoraMigrate::DatastreamMover
  def after_datastream_migration
    # additional actions as needed
  end

end
desc "Revert the CurationConcerns id translators"
task id_migrators: :environment do
  GenericWork.translate_id_to_uri = ActiveFedora::Core::FedoraIdTranslator
  GenericWork.translate_uri_to_id = ActiveFedora::Core::FedoraUriTranslator
  FileSet.translate_id_to_uri = ActiveFedora::Core::FedoraIdTranslator
  FileSet.translate_uri_to_id = ActiveFedora::Core::FedoraUriTranslator
  Collection.translate_id_to_uri = ActiveFedora::Core::FedoraIdTranslator
  Collection.translate_uri_to_id = ActiveFedora::Core::FedoraUriTranslator
end
desc "Delete all the content in Fedora 4"
task clean: :id_migrators do
  ActiveFedora::Cleaner.clean!
end
namespace :migrate do
desc "Run my migrations"
  task list: :id_migrators do
    list = ENV['list']
    unless list && File.exists?(list)
      puts "usage: rake migrate:list list=LIST_PATH"
    else
      ac = ::RDF::URI("info:fedora/ac#")
      migrator = FedoraMigrate::AcademicCommons::ListMigrator.new('ac', list:list,prefixes:{ac:ac})
      migrator.migrate_objects
      migrator.migrate_relationships # this is where we need to add DC and RELS-INT migration
      migrator
    end
  end
end