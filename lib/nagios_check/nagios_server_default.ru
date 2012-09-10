require 'sinatra'
require 'async_sinatra'

class NagiosDefaultApp < Sinatra::Base
  register Sinatra::Async

  aget '/check/:method' do
    Nagios::RunnerAsync.new(params) do |res|
      body JSON.generate(res)
    end
  end

end

run NagiosDefaultApp.new