# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActiveFedora::Base.translate_id_to_uri = ActiveFedora::Core::FedoraIdTranslator
ActiveFedora::Base.translate_uri_to_id = ActiveFedora::Core::FedoraUriTranslator
GenericWork.translate_id_to_uri = ActiveFedora::Core::FedoraIdTranslator
GenericWork.translate_uri_to_id = ActiveFedora::Core::FedoraUriTranslator
FileSet.translate_id_to_uri = ActiveFedora::Core::FedoraIdTranslator
FileSet.translate_uri_to_id = ActiveFedora::Core::FedoraUriTranslator
Collection.translate_id_to_uri = ActiveFedora::Core::FedoraIdTranslator
Collection.translate_uri_to_id = ActiveFedora::Core::FedoraUriTranslator
