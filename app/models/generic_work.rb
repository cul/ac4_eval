# Generated via
#  `rails generate curation_concerns:work GenericWork`
class GenericWork < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Sufia::WorkBehavior
  include LegacyProperties
  include AcademicCommonsProperties
  validates :title, presence: { message: 'Your work must have a title.' }
end
