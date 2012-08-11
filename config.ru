require 'sinatra/base'

$:.unshift File.expand_path('../lib', __FILE__)

require 'get_name'

class App < Sinatra::Base
  get "/favicon.ico" do
    404
  end

  get "/animal" do
    content_type :text
    GetName['', Animal]
  end

  get "/similar/:words" do
    content_type :text
    GetName[params[:words], Similar]
  end

  get "/permute/:words" do
    content_type :text
    GetName[params[:words], Permutations]
  end
end

run App.new
