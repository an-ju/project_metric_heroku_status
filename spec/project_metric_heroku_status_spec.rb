RSpec.describe ProjectMetricHerokuStatus do

  context 'meta data' do
    it "has a version number" do
      expect(ProjectMetricHerokuStatus::VERSION).not_to be nil
    end
  end

  context 'generate data' do
    before :each do
      stub_request(:get, 'https://api.heroku.com/apps/teamscope/releases')
        .to_return(body: File.read('spec/data/releases.json'))

    end

    subject(:heroku_status_metric_sample) do
      described_class.new heroku_app: 'teamscope', heroku_token: 'fake_token'
    end

    it 'gives 100 score when it returns 302' do
      stub_request(:get, 'https://teamscope.herokuapp.com/')
          .to_return(body: 'resp body', status: 302)
      expect(heroku_status_metric_sample.score).to eql(100)
    end

    it 'gives 100 score when it returns 200' do
      stub_request(:get, 'https://teamscope.herokuapp.com/')
          .to_return(body: 'resp body', status: 200)
      expect(heroku_status_metric_sample.score).to eql(100)
    end

    it 'gives 0 score when it returns 404' do
      stub_request(:get, 'https://teamscope.herokuapp.com/')
          .to_return(body: 'resp body', status: 404)
      expect(heroku_status_metric_sample.score).to eql(0)
    end

    it 'sets up image data correctly' do
      stub_request(:get, 'https://teamscope.herokuapp.com/')
          .to_return(body: 'resp body', status: [200, 'OK'])
      image = heroku_status_metric_sample.image
      expect(image).to have_key(:data)
      expect(image[:data][:release].length).to eql(2)
      expect(image[:data][:web_status]).to eql(200)
      expect(image[:data][:web_response]).to eql('OK')
      expect(image[:data][:app_link]).to eql('https://teamscope.herokuapp.com/')
    end

    it 'returns obj_id correctly' do
      stub_request(:get, 'https://teamscope.herokuapp.com/')
          .to_return(body: 'resp body', status: 200)
      expect(heroku_status_metric_sample.obj_id).to eql('01234567-89ab-cdef-0123-456789abcdef')
    end

  end

  context 'data generator' do
    it 'generates a list of fake data' do
      expect(described_class.fake_data.length).to eql(3)
    end

    it 'contains correct image data' do
      image = described_class.fake_data.first[:image]
      expect(image).to have_key(:data)
      expect(image[:data][:release].length).to be > 0
      expect(image[:data][:web_status]).not_to be_nil
      expect(image[:data][:web_response]).not_to be_nil
      expect(image[:data][:app_link]).not_to be_nil
    end
  end

end
