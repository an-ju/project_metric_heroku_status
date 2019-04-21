require "project_metric_heroku_status/version"
require 'project_metric_heroku_status/test_generator'
require 'faraday'
require 'faraday_middleware'
require 'json'

require 'project_metric_base'

class ProjectMetricHerokuStatus
  include ProjectMetricBase
  add_credentials %I[heroku_app heroku_token]
  add_raw_data %w[heroku_releases heroku_webpage]

  def initialize(credentials = {}, raw_data = nil)
    @heroku_app = credentials[:heroku_app]

    @conn = Faraday.new(url: 'https://api.heroku.com/') do |conn|
      conn.use :gzip
      conn.adapter Faraday.default_adapter
    end
    @conn.headers['Accept'] = 'application/vnd.heroku+json; version=3'
    @conn.headers['Authorization'] = "Bearer #{credentials[:heroku_token]}"

    complete_with raw_data

  end

  def image
    { chartType: 'heroku_status',
      data: { release: recent_releases,
              forbidden: @heroku_releases.class.eql?(Hash),
              web_status: @heroku_webpage['status'],
              web_response: @heroku_webpage['reason_phrase'],
              app_link: "https://#{@heroku_app}.herokuapp.com/"
      } }
  end

  def score
    @heroku_webpage['status'] < 400 ? 100 : 0
  end

  def obj_id
    @heroku_releases.find { |r| r['status'] == 'succeeded' }['id']
  end

  private

  def heroku_releases
    @heroku_releases = JSON.parse(@conn.get("apps/#{@heroku_app}/releases").body)
  end

  def heroku_webpage
    resp = Faraday.get "https://#{@heroku_app}.herokuapp.com/"
    @heroku_webpage = { 'status' => resp.status,
                        'reason_phrase' => resp.reason_phrase,
                        'location' => resp.headers['location'] }
  end

  def recent_releases
    if @heroku_releases.class.eql? Hash
      return nil
    end
    @heroku_releases.select { |r| Date.iso8601(r['created_at']) >= (Date.today - 14) }
  end
end
