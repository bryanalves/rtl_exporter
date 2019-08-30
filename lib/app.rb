class App < Sinatra::Base
  configure do
    set :server, :puma
    set :bind, '0.0.0.0'
    set :port, 9100
  end

  get '/metrics' do
    Prometheus::Client::Formats::Text.marshal(PromRegistry.registry)
  end
end
