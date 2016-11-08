ENV['RACK_ENV'] = 'test'

require './app'
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

describe 'The vulnshop.rb App' do
  def app
    Sinatra::Application
  end

  it "welcomes" do
    get '/'
    puts last_response
    expect(last_response).to be_ok
    expect(last_response.body).to eq("Welcome to VulnShop")
  end
end
