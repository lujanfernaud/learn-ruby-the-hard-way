require "bundler"
Bundler.require

ENV["RACK_ENV"] ||= "development"

DB = Sequel.connect "sqlite://db/#{ENV["RACK_ENV"]}.sqlite3"

require "./bin/app.rb"
require "./bin/score.rb"

run App