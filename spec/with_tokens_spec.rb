require "spec_helper"

RSpec.describe ProjectMetricHerokuStatus do

  before :each do
    WebMock.allow_net_connect!
  end
  subject(:metric) do
    tokens = JSON.parse(File.read('spec/data/tokens.json'))
    described_class.new(heroku_app: tokens['heroku_app'], heroku_token: tokens['heroku_token'])
  end

  it 'initializes properly' do
    expect(metric).not_to be_nil
  end

  it 'sets image properly' do
    expect(metric.image).not_to be_nil
  end

  it 'sets score properly' do
    expect(metric.score).not_to be_nil
  end

  it 'gets all releases' do
    expect(metric.raw_data['heroku_releases'].length).to be > 1
  end

  it 'gets more than one releases' do
    expect(metric.image[:data][:release].length).to be > 1
  end
end
