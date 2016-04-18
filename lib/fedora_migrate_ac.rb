module FedoraMigrate
  module AcademicCommons
    MEMBER_OF = ::RDF::URI('http://purl.oclc.org/NET/CUL/memberOf')
    METADATA_FOR = ::RDF::URI('http://purl.oclc.org/NET/CUL/metadataFor')

    def self.sparql_outbound(subject, predicate)
      <<-SPARQL
          SELECT ?pid FROM <#ri> WHERE {
            <#{subject}> <#{predicate}> ?pid
          }
        SPARQL
    end

    def self.sparql_inbound(object, predicate)
      <<-SPARQL
          SELECT ?pid FROM <#ri> WHERE {
            ?pid <#{predicate}> <#{object}>
          }
        SPARQL
    end
    autoload :DescMetadataMover, 'fedora_migrate_ac/desc_metadata_mover'
    autoload :ListDescriber, 'fedora_migrate_ac/list_describer'
    autoload :ListMigrator, 'fedora_migrate_ac/list_migrator'
    autoload :ListProcessor, 'fedora_migrate_ac/list_processor'
    autoload :ModsPropertyMover, 'fedora_migrate_ac/mods_property_mover'
    autoload :ObjectDescriber, 'fedora_migrate_ac/object_describer'
    autoload :ObjectMover, 'fedora_migrate_ac/object_mover'
    autoload :OverrideTargetConstructor, 'fedora_migrate_ac/override_target_constructor'
    autoload :RelsExtDatastreamMover, 'fedora_migrate_ac/rels_ext_datastream_mover'
  end
end
