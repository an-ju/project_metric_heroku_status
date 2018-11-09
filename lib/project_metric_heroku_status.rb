require "project_metric_heroku_status/version"
require 'project_metric_heroku_status/test_generator'
require 'faraday'
require 'json'

class ProjectMetricHerokuStatus
  attr_reader :raw_data

  def initialize(credentials = {}, raw_data = nil)
    @heroku_app = credentials[:heroku_app]

    @conn = Faraday.new(url: 'https://api.heroku.com/')
    @conn.headers['Accept'] = 'application/vnd.heroku+json; version=3'
    @conn.headers['Authorization'] = "Bearer #{credentials[:heroku_token]}"

    @raw_data = raw_data
  end

  def image
    refresh unless @raw_data

    { chartType: 'heroku_status',
      data: { release: first_success,
              web_status: @webpage.status,
              web_response: @webpage.reason_phrase
      } }.to_json
  end

  def score
    refresh unless @raw_data

    @webpage.status < 400 ? 100 : 0
  end

  def commit_sha
    nil
  end

  def raw_data=(new)
    @raw_data = new
    @score = @image = nil
  end

  def refresh
    set_releases
    set_webpage
    @raw_data = { releases: @releases,
                  webpage: { status: @webpage.status,
                             location: @webpage.headers['location'],
                             body: @webpage.body
                  } }.to_json
    true
  end

  def self.credentials
    %I[heroku_app heroku_token]
  end

  private

  def set_releases
    @releases = JSON.parse(@conn.get("app/#{@heroku_app}/releases").body)
  end

  def set_webpage
    @webpage = Faraday.get "https://#{@heroku_app}.herokuapp.com/"
  end

  def first_success
    success_release = @releases.find_index { |r| r['status'] == 'succeeded' }
    success_release ? @releases[0..success_release] : nil
  end
end
