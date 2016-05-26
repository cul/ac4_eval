# Generated via
#  `rails generate curation_concerns:work GenericWork`
require 'rails_helper'
include Warden::Test::Helpers

feature 'Get a non-Sufia static page' do
  scenario do
    skip "This is skipped in sufia "

    visit static_path(:content_policies)
    expect(page).to have_content 'Collection Development Policy'
  end
end
