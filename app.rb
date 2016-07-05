require 'sinatra'
require 'sinatra-enotify'
require 'sinatra/activerecord'
require 'openssl-stubs'
require 'activemerchant'
require './models'

Sinatra::register Sinatra::ENotify
configure_enotify({ redis: false })

configure :development do
  set :show_exceptions, false
  set :dump_errors, false
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

require './routes'

error do
  enotify env['sinatra.error']
  @page = :exception
  erb :template
end
