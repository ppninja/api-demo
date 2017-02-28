require 'spec_helper'

RSpec.describe Ppninja::Signature do
  subject do
    Ppninja::HttpClient.new('http://host/', 20, false)
  end

  let(:response_params) do
    {
      headers: { content_type: 'text/plain' },
      status: 200
    }
  end

  let(:response_json) do
    double 'json', response_params.merge(body: { result: 'success' }.to_json,
                                         headers: { content_type: 'application/json' })
  end

  describe '#get' do
    specify 'Will use http get method to request data' do
      allow(subject.httprb).to receive_message_chain('headers.get') { response_json }
      subject.get('token')
    end
  end

  describe '#post' do
    specify 'Will use http post method to request data' do
      allow(subject.httprb).to receive_message_chain('headers.post') { response_json }
      subject.post('token', 'some_data')
    end
  end
end
