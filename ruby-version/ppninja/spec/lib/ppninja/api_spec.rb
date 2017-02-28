require 'spec_helper'

RSpec::Matchers.define :with_signature_of do |opts = nil|
  match do |actual|
    actual[:"X-Ppj-Credential"] && actual[:"X-Ppj-Timestamp"] && actual[:"X-Ppj-Signature"] && (!opts || opts.keys.map { |k| opts[k] === actual[k] }.inject(1) { |product, n| product && n })
  end
end

RSpec.describe Ppninja::Api do
  subject do
    Ppninja::Api.new('appid', 'appsecret', 'host')
  end

  describe '#list' do
    specify 'will get correct list' do
      expect(subject.client).to receive(:get).with('/api/job/list', params: with_signature_of).and_return(true)
      expect(subject.list).to eq(true)
    end
  end

  describe '#status' do
    specify 'will get correct status' do
      expect(subject.client).to receive(:get).with('/api/job/status', params: with_signature_of(token: 'token')).and_return(true)
      expect(subject.status('token')).to eq(true)
    end
  end

  describe '#upload' do
    specify 'will upload correctly' do
      file = File.join(Dir.getwd, 'spec/examples.txt')
      md5 = Digest::MD5.hexdigest(File.read(file))
      expect(subject.client).to receive(:post_file).with('/api/job/create', file, params: with_signature_of(file_md5: md5)).and_return(true)
      expect(subject.upload(file)).to eq(true)
    end
  end

  describe '#download' do
    specify 'will download correctly' do
      file = File.join(Dir.getwd, 'spec/download_examples.txt')
      expect(subject.client).to receive(:get).with('/api/job/download', params: with_signature_of(token: 'token'), content_type: 'application/zip').and_return(true)
      expect(subject.download('token')).to eq(true)
    end
  end
end
