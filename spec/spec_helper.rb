require 'rubygems'
require 'bundler'

Bundler.setup(:default, :test)

require 'webmock/rspec'
require_relative './../lib/weito'
