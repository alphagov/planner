require 'statsd'
require 'rack-statsd'

METRICS = Statsd.new('localhost', 8125)
Rails.application.middleware.insert_before ActionDispatch::Static, RackStatsD::ProcessUtilization, nil, nil, {:stats => METRICS} unless Rails.env.developent? or Rails.env.test?

