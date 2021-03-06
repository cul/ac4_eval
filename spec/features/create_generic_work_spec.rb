# Generated via
#  `rails generate curation_concerns:work GenericWork`
require 'rails_helper'
include Warden::Test::Helpers

feature 'Create a GenericWork' do
  context 'a logged in user' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.find_or_create_by(user_attributes)
    end

    before do
      login_as user
    end

    scenario do
      skip "This is skipped in sufia "

      visit new_curation_concerns_generic_work_path
      fill_in 'Title', with: 'Test GenericWork'
      puts page.body
      click_button 'Create GenericWork'
      expect(page).to have_content 'Test GenericWork'
    end
  end
end
