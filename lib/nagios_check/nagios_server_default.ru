require 'sinatra'
require 'async_sinatra'

class NagiosDefaultApp < Sinatra::Base
  register Sinatra::Async

  aget '/check/:method' do
    Nagios::Runner.new(params) do |status, message|
      body JSON.generate({:status => status, :message => message})
    end
  end

end

run NagiosDefaultApp.new