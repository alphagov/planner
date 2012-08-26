require 'statsd'
require 'rack-statsd'

METRICS = Statsd.new('localhost', 8125)
Rails.application.middleware.insert_before Rack::Lock, RackStatsD::ProcessUtilization, nil, nil, {:stats => METRICS} unless Rails.env.developent? or Rails.env.test?

