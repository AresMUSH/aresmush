module AresMUSH
  class WebApp

    get '/help/:topic/?' do |search|
      if (search.end_with?("."))
        search = search.chop
      end
      
      topics = Help.find_topic(search)
      
      if (topics.empty?)
        flash[:error] = "Help topic not found!"
        redirect "/help"
      end
      
      topic = topics.first
      contents = Help.topic_contents(topic)
      @help =  format_markdown_for_html(contents)
      @search = params[:search]
      @page_title = "Help - #{topic.titleize} - #{game_name}"
      erb :"help/help"
    end

    get '/help/:plugin/:topic/?' do |plugin, topic|
      redirect "/help/#{topic}"
    end
    
  end
end
