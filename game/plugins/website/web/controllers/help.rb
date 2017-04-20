module AresMUSH
  class WebApp
    get '/help' do
      @topics = {}
      
      
      Help.toc.each do |toc|
        if (params[:list])
          @topics[toc] = Help.toc_topics(toc)
          @show_full = true
        else
          @topics[toc] = Help.toc_topics(toc).select { |k, v| v['topic'] == 'index' }
          @show_full = false
        end
      end
      
      uncategorized =  Help.toc_topics(nil)
      if (uncategorized.count > 0)
        @topics["Uncategorized"] = uncategorized
      end
      
      erb :help_index
    end

    get '/help/:plugin/:topic' do |plugin, topic|
      @topic = topic.titlecase
      path = File.join( AresMUSH.game_path, "plugins", plugin, "help", "#{topic}.md" )
      md = MarkdownFile.new(path)
      text = ClientFormatter.format md.contents, false
      formatter = MarkdownFormatter.new
      @help =  formatter.to_html(text)
      erb :help
    end
  end
end
