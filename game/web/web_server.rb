module AresMUSH
  class AresWeb < Angelo::Base

    # just some constants to use in routes later...
    #
    TEST = {foo: "bar", baz: 123, bat: false}.to_json
    HEART = '<3'
    CORS = { 'Access-Control-Allow-Origin' => '*',
               'Access-Control-Allow-Methods' => 'GET, POST',
               'Access-Control-Allow-Headers' => 'Accept, Authorization, Content-Type, Origin' }

    # a flag to know if the :heart task is running
    #
    @@hearting = false

    # you can define instance methods, just like Sinatra!
    #
    def pong; 'pong'; end
    def foo; params[:foo]; end

  
    before '/api/*' do
      headers CORS
      if request.path == "/api/tokenauth" 
        puts "Token auth"      
      elsif request.headers['Authorization'] == "Bearer 123"      
        puts "Auth OK"
      elsif request.method == "OPTIONS"
        puts "Options OK"
      else
        puts "Failed authentication"
        raise RequestError.new 'not authorized', 401
      end
    end

    options '/cors' do
      headers CORS
      nil
    end

    options '*' do
      headers CORS
      nil
    end
  
    # standard HTTP GET handler
    #
    get '/ping' do
      pong
    end
  
    get '/api/characters' do
      headers CORS
      content_type :json
      data = 
      [
          {
            id: 0,
            name: "A",
            desc: "a desc"
          },
          {
            id: 1,
            name: "B",
            desc: "b desc"
          }
        ]
        puts "Getting #{data}"
      data.to_json
      
      Character.all
    end
  

    post '/api/tokenauth' do
      headers CORS
      content_type :json

      data = { token: 123 }
      puts "Getting auth token."
      data.to_json
    end
  
  
    # standard HTTP POST handler
    #
    post '/foo' do
      foo
    end

    post '/bar' do
      params.to_json
    end

    # emit the TEST JSON value on all :emit_test websockets
    # return the params posted as JSON
    #
    post '/emit' do
      websockets[:emit_test].each {|ws| ws.write TEST}
      params.to_json
    end

    # handle websocket requests at '/ws'
    # stash them in the :emit_test context
    # write 6 messages to the websocket whenever a message is received
    #
    websocket '/ws' do |ws|
      websockets[:emit_test] << ws
      ws.on_message do |msg|
        5.times { ws.write TEST }
        ws.write foo.to_json
      end
    end

    # emit the TEST JSON value on all :other websockets
    #
    post '/other' do
      websockets[:other].each {|ws| ws.write TEST}
      ''
    end

    # stash '/other/ws' connected websockets in the :other context
    #
    websocket '/other/ws' do |ws|
      websockets[:other] << ws
    end

    websocket '/hearts' do |ws|

      # this is a call to Base#async, actually calling
      # the reactor to start the task
      #
      async :hearts unless @@hearting

      websockets[:hearts] << ws
    end

    # this is a call to Base.task, defining the task
    # to perform on the reactor
    #
    task :hearts do
      @@hearting = true
      every(10){ websockets[:hearts].each {|ws| ws.write HEART } }
    end

    post '/in/:sec/sec/:msg' do

      # this is a call to Base#future, telling the reactor
      # do this thing and we'll want the value eventually
      #
      f = future :in_sec, params[:sec], params[:msg]
      f.value
    end

    # define a task on the reactor that sleeps for the given number of
    # seconds and returns the given message
    #
    task :in_sec do |sec, msg|
      sleep sec.to_i
      msg
    end

    # return a chunked response of JSON for 5 seconds
    #
    get '/chunky_json' do
      content_type :json

      # this helper requires a block that takes one arg, the response
      # proc to call with each chunk (i.e. the block that is passed to
      # `#each`)
      #
      chunked_response do |response|
        5.times do
          response.call time: Time.now.to_i
          sleep 1
        end
      end
    end

  end
end