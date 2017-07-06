module AresMUSH
  class WebApp
    get '/help' do
      @topics = {}
      
      if (params[:list])
        show_full = true
      else
        show_full = false
      end
      
      Help.toc.each do |toc|
        if (show_full)
          @topics[toc] = Help.toc_topics(toc)
        else
          index_topics = Help.toc_topics(toc).select { |k, v| v['topic'] == 'index' }
          @topics[toc] = index_topics
        end
      end
      
      uncategorized =  Help.toc_topics(nil)
      if (uncategorized.count > 0)
        @topics["Uncategorized"] = uncategorized
      end
      
      if (show_full)
        erb :"help/help_full_index"
      else
        erb :"help/help_index"
      end
    end
  end
end
