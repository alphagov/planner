require 'statsd'
require 'rack-statsd'

METRICS = Statsd.new('localhost', 8125)

metric_path = []
metric_path << `hostname -s`.chomp
metric_path << 'planner'

Rails.application.middleware.insert_before Rack::Lock, RackStatsD::ProcessUtilization, nil, nil, {:stats => METRICS, :hostname => metric_path.join('.')} unless Rails.env.developent? or Rails.env.test?

