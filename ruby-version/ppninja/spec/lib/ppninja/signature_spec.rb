require 'spec_helper'

RSpec.describe Ppninja::Signature do
  subject do
    Ppninja::Signature.new('appid')
  end

  describe '#sign' do
    specify 'will get signature' do
      queries = {}
      http_method = 'http_method'
      path = 'my_path'
      timestamp = 'my_timestamp'
      signature = '0e8b444b883e7251f8b90e055a80c89dc688d7fb8a23d535494dcac9dd63d36f'
      expect(subject.sign(queries, http_method, path, timestamp)).to eq signature

      queries = {'abc': 1, Vdc: '2', random: false, Jesus: 'queries'}
      http_method = 'get'
      path = '/path/by'
      timestamp = 2017022929
      signature = '9b23e189d4a944db007ee3b3b19641eaeb8adf5d7657da471f18726fa3dc245a'
      expect(subject.sign(queries, http_method, path, timestamp)).to eq signature

    end
  end
end
