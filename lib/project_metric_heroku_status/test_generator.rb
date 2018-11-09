class ProjectMetricHerokuStatus
  def self.fake_data
    [_metric_sample(200, 'OK'), _metric_sample(302, 'Found'), _metric_sample(404, 'Not Found')]
  end

  def self._metric_sample(status, reason)
    { image: {
        data: {
           release: releases,
           web_status: status,
           web_response: reason
        },
       chartType: 'heroku_status'
      }.to_json,
      score: status > 400 ? 0 : 100
    }
  end

  def self.releases
    [
        {
            "addon_plan_names": [
                "heroku-postgresql:dev"
            ],
            "app": {
                "name": "example",
                "id": "01234567-89ab-cdef-0123-456789abcdef"
            },
            "created_at": "2012-01-01T12:00:00Z",
            "description": "Added new feature",
            "id": "01234567-89ab-cdef-0123-456789abcdef",
            "updated_at": "2012-01-01T12:00:00Z",
            "slug": {
                "id": "01234567-89ab-cdef-0123-456789abcdef"
            },
            "status": "failed",
            "user": {
                "id": "01234567-89ab-cdef-0123-456789abcdef",
                "email": "username@example.com"
            },
            "version": 11,
            "current": true,
            "output_stream_url": "https://release-output.heroku.com/streams/01234567-89ab-cdef-0123-456789abcdef"
        },
        {
            "addon_plan_names": [
                "heroku-postgresql:dev"
            ],
            "app": {
                "name": "example",
                "id": "01234567-89ab-cdef-0123-456789abcdef"
            },
            "created_at": "2011-12-01T12:00:00Z",
            "description": "Added new feature",
            "id": "01234567-89ab-cdef-0123-456789abcdef",
            "updated_at": "2012-12-01T12:00:00Z",
            "slug": {
                "id": "01234567-89ab-cdef-0123-456789abcdef"
            },
            "status": "succeeded",
            "user": {
                "id": "01234567-89ab-cdef-0123-456789abcdef",
                "email": "username@example.com"
            },
            "version": 11,
            "current": true,
            "output_stream_url": "https://release-output.heroku.com/streams/01234567-89ab-cdef-0123-456789abcdef"
        }
    ]
  end
end