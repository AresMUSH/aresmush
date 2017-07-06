module AresMUSH
  class WebApp
    get '/chars' do
      @chars = Chargen.approved_chars.sort_by { |c| c.name }
      erb :"chars/index"
    end
    
    get '/char/:id' do |id|
      @char = Character[id]
      if (!@char)
        flash[:error] = "Character not found."
        redirect '/chars'
      end
      
      erb :"chars/char"
    end
  end
end
