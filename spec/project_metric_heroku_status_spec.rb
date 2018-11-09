RSpec.describe ProjectMetricHerokuStatus do

  context 'meta data' do
    it "has a version number" do
      expect(ProjectMetricHerokuStatus::VERSION).not_to be nil
    end
  end

  context 'generate data' do
    before :each do
      @conn = double('conn')
      releases_resp = double('releases')
      allow(releases_resp).to receive(:body) { File.read './spec/data/releases.json' }
      @webpage_resp = double('webpage')
      allow(@webpage_resp).to receive(:headers).and_return({ 'location' => 'location from header'})
      allow(@webpage_resp).to receive(:body).and_return('resp body')

      expect(Faraday).to receive(:new).and_return(@conn)
      allow(@conn).to receive(:headers).and_return({})
      allow(@conn).to receive(:get).with('app/teamscope/releases').and_return(releases_resp)
      expect(Faraday).to receive(:get).and_return(@webpage_resp)
    end

    subject(:heroku_status_metric_sample) do
      described_class.new heroku_app: 'teamscope', heroku_token: 'fake_token'
    end

    it 'gives 100 score when it returns 302' do
      allow(@webpage_resp).to receive(:status).and_return(302)
      expect(heroku_status_metric_sample.score).to eql(100)
    end

    it 'gives 100 score when it returns 200' do
      allow(@webpage_resp).to receive(:status).and_return(200)
      expect(heroku_status_metric_sample.score).to eql(100)
    end

    it 'gives 0 score when it returns 404' do
      allow(@webpage_resp).to receive(:status).and_return(404)
      expect(heroku_status_metric_sample.score).to eql(0)
    end

    it 'sets up image data correctly' do
      allow(@webpage_resp).to receive(:status).and_return(200)
      allow(@webpage_resp).to receive(:reason_phrase).and_return('OK')
      image = JSON.parse(heroku_status_metric_sample.image)
      expect(image).to have_key('data')
      expect(image['data']['release'].length).to eql(2)
      expect(image['data']['web_status']).to eql(200)
      expect(image['data']['web_response']).to eql('OK')
    end

  end

  context 'data generator' do
    it 'generates a list of fake data' do
      expect(described_class.fake_data.length).to eql(3)
    end

    it 'contains correct image data' do
      image = JSON.parse(described_class.fake_data.first[:image])
      expect(image).to have_key('data')
      expect(image['data']['release'].length).to be > 0
      expect(image['data']['web_status']).not_to be_nil
      expect(image['data']['web_response']).not_to be_nil
    end
  end

end
