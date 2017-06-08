require 'rubygems'
require 'bundler'

gem_groups = [:default, (ENV['RACK_ENV'] || 'development').to_sym]

Bundler.require(*gem_groups)

require './app'
run Sinatra::Application