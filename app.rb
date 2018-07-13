require 'sinatra'

configure do
  set :server, :puma
  set :bind, "0.0.0.0"
  set :protection, except: [:frame_options, :json_csrf]
  set :root, File.dirname(__FILE__)
end


get '/' do
  puts "beginning response. Check back in a while and you can see the report"
  puts "beginning response. Check back in a while and you can see the report"
  Thread.new do
    puts "starting script"
    `bin2/scta-rdf extract_all`
    puts $?.pid
    puts $?.success?
  end
end
