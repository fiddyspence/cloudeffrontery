require_relative '../lib/cloudeffrontery.rb'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)
SPECROOT=File.dirname(__FILE__)

