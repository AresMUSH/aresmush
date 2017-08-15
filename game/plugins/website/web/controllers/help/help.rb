module AresMUSH
  class WebApp
    get '/help/?' do
      @topics = {}
      
      if params['root']
        redirect "/help/#{params['root']} #{params['switch']}?search=#{params['switch']}"
      end
      
      Help.toc.keys.sort.each do |toc|
        @topics[toc] = Help.toc_section_topic_data(toc)
      end
      
      erb :"help/help_index"
    end
    
  end
end
