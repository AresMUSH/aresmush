module AresMUSH
  class WebApp

    get '/help/:topic/?' do |topic|
      topic = Help.find_topic(topic)
      
      if (!topic == 0)
        flash[:error] = "Help topic not found!"
        redirect "/help"
      end
      
      contents = Help.topic_contents(topic.first)
      @help =  format_markdown_for_html(contents)
      @search = params[:search]
      erb :"help/help"
    end

    get '/help/:plugin/:topic/?' do |plugin, topic|
      redirect "/help/#{topic}"
    end
    
  end
end
