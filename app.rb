#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'json'

get '/hi/:name' do
  content_type :json
  { static: "##STATIC##", dynamic: "##DYN##"}.
    to_json.
    gsub("\"##STATIC##\"", '<esi:include src="/static" />').
    gsub("\"##DYN##\"", "<esi:include src=\"/dynamic/#{params[:name]}\" />")
end

get '/static' do
  content_type :json
  { message: 'hello' }.to_json
end

get '/dynamic/:name' do
  content_type :json
  { name: params[:name] }.to_json
end
