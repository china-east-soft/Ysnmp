# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Ysnmp::Application.initialize!

RRDPath = File.expand_path('../rrd', Rails.root)
RRDImg = File.expand_path('./app/assets/images/rrd', Rails.root)