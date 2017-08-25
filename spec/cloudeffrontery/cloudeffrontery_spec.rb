require 'spec_helper'

STUBJSON = File.join(SPECROOT,'fixtures','json.json')
FILTERJSON = File.join(SPECROOT,'fixtures','filterjson.json')

describe 'print some shit' do
  before :each do
    @thing = Cloudeffrontery.new
    stub_request(:get, "https://ip-ranges.amazonaws.com/ip-ranges.json").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: File.read(STUBJSON), headers: {})
  end

  it 'returns some json' do
    expect(@thing.retrieve).to be_a(Array)
  end

  it 'returns nil' do
    stub_request(:get, "https://ip-ranges.amazonaws.com/ip-ranges.json").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(status: 404, body: File.read(STUBJSON), headers: {})
    expect(@thing.retrieve).to be nil
  end

  it 'returns an bunch of nginx configs' do
    expect(@thing.nginx).to be_a(String)
    expect(@thing.nginx).to match(/set_real_ip_from/)
  end
  it 'returns an bunch of Apache configs' do
    expect(@thing.apache).to be_a(String)
    expect(@thing.apache).to match(/Cloudfront public IPs/)
  end

end

describe 'test the filtering' do
  before :each do
    @thing = Cloudeffrontery.new
    @filterhash = JSON.parse(File.read(FILTERJSON))
  end

  it 'returns an array of prefixes' do
    expect(@thing.filter(@filterhash)).to be_a(Array)
    expect(@thing.filter(@filterhash).size).to be 4
  end
  it 'returns an array of prefixes' do
    @thing.service = 'FOO'
    expect(@thing.filter(@filterhash)).to be_a(Array)
    expect(@thing.filter(@filterhash).size).to be 0
  end
  it 'returns an array of prefixes' do
    @thing.region= 'us-east'
    expect(@thing.filter(@filterhash)).to be_a(Array)
    expect(@thing.filter(@filterhash).size).to be 1
  end
  it 'returns nil' do
    expect(@thing.filter("some string")).to be nil
  end


end
