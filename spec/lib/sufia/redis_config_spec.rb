require 'rails_helper'
describe Sufia::RedisConfig, type: :unit do
  let(:config_fixtures) { File.join(RSpec.configuration.fixture_path, 'sufia', 'redis_config') }
  let(:config_path) { File.join(config_fixtures, 'redis.yml') }
  let(:alternate_config_path) { File.join(config_fixtures, 'alternate.yml') }
  let(:redis_config) { described_class.configuration(config_path) }
  let(:alternate_config) { described_class.configuration(alternate_config_path) }
  describe '.configuration' do
    context 'default configuration style' do
      subject { redis_config }
      it 'loads valid params and ignores extras in YAML' do
        is_expected.to have_key(:host)
        is_expected.to have_key(:port)
      end
    end
    context 'url configuration style' do
      subject { alternate_config }
      it 'loads valid params and ignores extras in YAML' do
        is_expected.to have_key(:url)
        is_expected.not_to have_key(:nonsense)
      end
      it 'produces a configured client' do
        redis_client = Redis::Client.new(alternate_config)
        expect(redis_client.host).to eql('localhost')
        expect(redis_client.port).to eql(6379)
        expect(redis_client.password).to eql('password')
      end
    end
  end
  describe '.configure' do
    context 'there is no current Redis configured' do
      before { Redis.current = nil }
      it 'sets Redis.current to a Redis::Namespace wrapper' do
        redis = double('Redis')
        expect(Redis).to receive(:new).with(redis_config).and_return(redis)
        described_class.configure(config_path)
        expect(Redis.current.namespace).to eql(Sufia::RedisConfig::REDIS_NAMESPACE)
      end
    end
  end
end
