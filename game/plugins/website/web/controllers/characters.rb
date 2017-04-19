module AresMUSH
  class WebApp
    get '/chars' do
      @chars = Idle::Api.active_chars.sort_by { |c| c.name }
      erb :chars_index
    end
    
    get '/char/:id' do |id|
      @char = Character[id]
      if (!@char)
        flash[:error] = "Character not found."
        redirect '/chars'
      end
      
      erb :char
    end
  end
end
