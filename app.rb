require 'sinatra'

configure do
  set :server, :puma
  set :bind, "0.0.0.0"
  set :protection, except: [:frame_options, :json_csrf]
  set :root, File.dirname(__FILE__)
end


get '/' do
  "scta-rdf updater. Are you a human? There's nothing really here for you"
end

get '/update' do
  # request.body.rewind
  # payload_body = request.body.read
  # verify_signature(payload_body)


  "beginning response. Check back in a while and you can see the report"
  puts "beginning response. Check back in a while and you can see the report"
  Thread.new do
    puts "starting script"
    `bin2/scta-rdf extract_all`
    puts $?.pid
    puts $?.success?
    `bin2/scta-rdf update_all_graphs`
    puts $?.pid
    puts $?.success?
  end
end

get '/text-update' do
  # request.body.rewind
  # payload_body = request.body.read
  # verify_signature(payload_body)



  "beginning response. Check back in a while and you can see the report"
  puts "beginning response. Check back in a while and you can see the report"
  #textrepo = params["textrepo"]
  textrepo = "plaoulcommentary"
  Thread.new do

    `curl -L -o data/scta-texts/#{textrepo}.tar https://api.github.com/repos/scta-texts/#{textrepo}/tarball/master && \
        tar -xvzf data/scta-texts/#{textrepo}.tar --directory data/scta-texts/ && \
        mv data/scta-texts/scta-texts-#{textrepo}* data/scta-texts/#{textrepo} && \
        rm data/scta-texts/#{textrepo}.tar`
    puts $?.pid
    puts $?.success?
    puts "starting script"
    `bin2/scta-rdf extract_all`
    puts $?.pid
    puts $?.success?
    `bin2/scta-rdf update_all_graphs`
    puts $?.pid
    puts $?.success?
  end
end
def verify_signature(payload_body)
  signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
  return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
end
