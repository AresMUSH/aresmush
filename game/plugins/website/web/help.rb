module AresMUSH
  class WebApp
    get '/help' do
      @topics = {}
      
      Help.toc("main").each do |toc|
        @topics[toc] = Help.toc_topics("main", toc)
      end

      uncategorized =  Help.toc_topics("main", nil)
      if (uncategorized.count > 0)
        @topics["Uncategorized"] = uncategorized
      end
      
      erb :help_index
    end
    
    get '/help/:topic' do |topic|
      @topic = topic.titlecase
      text = Help::Api.get_help(topic)
      text = ClientFormatter.format text, false
      formatter = MarkdownFormatter.new
      @help =  formatter.to_html(text)
      erb :help
    end
  end
end
