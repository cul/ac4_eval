require 'rails_helper'

describe Users::SessionsController do
  let(:root_url) { "/root_url" }
  let(:resource) { double('Requested Resource') }

  context "configured without CAS" do
    before do
      controller.instance_variable_set(:@omniauth_provider_key, :dummy)
      controller.instance_variable_set(:@omniauth_opts, {})
    end
    it "redirects to root url on logout" do
      expect(controller).to receive(:root_url).and_return(root_url)
      actual = controller.after_sign_out_path_for(resource)
      expect(actual).to eql(root_url)
    end
  end

  context "configured with CAS" do
    let(:config_fixtures) { File.join(RSpec.configuration.fixture_path, 'omniauth') }
    let(:config_path) { File.join(config_fixtures, 'cas.yml') }
    let(:test_config) { YAML.load_file(config_path)[Rails.env].symbolize_keys }

    before do
      controller.instance_variable_set(:@omniauth_provider_key, :saml)
      controller.instance_variable_set(:@omniauth_opts, test_config)
    end

    it "redirects to CAS logout url on logout" do
      allow(controller).to receive(:root_url).and_return(root_url)
      actual = controller.after_sign_out_path_for(resource)
      expect(actual).to match(/\?service=\%2Froot_url$/)
    end
  end
end
