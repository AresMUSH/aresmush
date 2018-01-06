module AresMUSH
  class WebApp    
    helpers do
     
      def recent_changes
        WikiPageVersion.all.to_a.reverse[0..200]
      end
    
      def unique_recent_page_changes
        WikiPageVersion.all.to_a.reverse[0..200].uniq { |w| w.wiki_page }
      end  
    end
    
    get '/wiki/recent_changes/?' do
      @recent = recent_changes
      
      erb :"wiki/recent_changes"
    end
    
    get '/wiki/create/?' do
      if (!is_approved?)
        flash[:error] = "Page not found.  You must be approved to create new pages."
        redirect '/wiki'
      end
      
      @name = params[:name] || ""
      @title = @name.titleize
      if (@title =~ /:/)
        @title = @title.after(":")
      end
      erb :"wiki/create_page"
    end
    
    get '/wiki/:page/source/:version/?' do |name_or_id, version_id|
      @page = WikiPage.find_by_name_or_id(name_or_id)
      @version = WikiPageVersion[version_id]
      
      if (!@page || !@version)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      
      @page_title = "#{@page.heading} - #{game_name}"
            
      erb :"wiki/page_source"
    end
    
    get '/wiki/:page/preview/?', :auth => :approved  do |name_or_id|
      
      @page = WikiPage.find_by_name_or_id(name_or_id)
      
      if (!@page)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      
      if (@page.is_special_page? && !is_admin?)
        flash[:error] = "You are not allowed to do that."
        redirect '/wiki'
      end
      
      @text = @page.preview['text']
      @name = @page.preview['name']
      @title = @page.preview['title']
      @tags = @page.preview['tags']
      
      erb :"wiki/edit_page"
    end
    
    get '/wiki/:page/draft/?', :auth => :approved  do |name_or_id|
      
      @page = WikiPage.find_by_name_or_id(name_or_id)
      
      if (!@page)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      
      if (@page.is_special_page? && !is_admin?)
        flash[:error] = "You are not allowed to do that."
        redirect '/wiki'
      end
      
      @text = @page.preview['text']
      @name = @page.preview['name']
      @title = @page.preview['title']
      @tags = @page.preview['tags']
      
      erb :"wiki/draft_page"
    end
    
    get '/wiki/:page/compare/:version_id/?', :auth => :approved  do |name_or_id, version_id|
      
      @page = WikiPage.find_by_name_or_id(name_or_id)
      @current = WikiPageVersion[version_id]
      
      if (!@page || !@current)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      
      all_versions = @page.wiki_page_versions.to_a.sort_by { |v| v.id }
      current_index = all_versions.index { |v| v.id == @current.id }
      if (!current_index || current_index <= 0)
        flash[:error] = "Previous version not found!"
        redirect "/wiki/#{name_or_id}/source/#{version_id}"
      end
      
      @previous = all_versions[current_index - 1]
      
      @diff = Diffy::Diff.new(@previous.text, @current.text).to_s(:html_simple)
      erb :"wiki/compare_page"
    end
    
    get '/wiki/:page/edit/?', :auth => :approved  do |name_or_id|
      
      @page = WikiPage.find_by_name_or_id(name_or_id)
      
      if (!@page)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      
      if (@page.is_special_page? && !is_admin?)
        flash[:error] = "You are not allowed to do that."
        redirect '/wiki'
      end
      
      
      if (@page.locked_by && (@page.locked_by != @user))
        expiry_time = @page.locked_time + 60*15
        if (Time.now  < expiry_time)
          flash[:error] = "That page is locked by #{@page.locked_by.name}.  Their lock will expire at #{OOCTime.local_long_timestr(@user, expiry_time)}."
          redirect "/wiki/#{name_or_id}"
        end
      end
      
      @page.update(locked_by: @user)
      @page.update(locked_time: Time.now)
      
      @text = @page.text
      @name = @page.name
      @title = @page.heading
      @tags = @page.tags_text
      
      erb :"wiki/edit_page"
    end
    
    get '/wiki/:page/rebuild/?', :auth => :approved  do |name_or_id|
      
      @page = WikiPage.find_by_name_or_id(name_or_id)
      
      if (!@page)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      
      @page.update(html: nil)
      redirect "/wiki/#{@page.name}"
    end
    
   
    get '/wiki/:page/revert/:version/?', :auth => :approved  do |name_or_id, version_id|
      @page = WikiPage.find_by_name_or_id(name_or_id)
      @version = WikiPageVersion[version_id]
      
      if (!@page || !@version)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      
      WikiPageVersion.create(wiki_page: @page, text: @version.text, character: @user)
      
      flash[:info] = "Page updated!"
      redirect "/wiki/#{@page.name}"
    end

    get '/wiki/:page/delete', :auth => :admin do |name_or_id|
      @page = WikiPage.find_by_name_or_id(name_or_id)
      if (!@page)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      erb :"wiki/delete_page"
    end
    
    get '/wiki/:page/delete/confirm', :auth => :admin do |name_or_id|
      @page = WikiPage.find_by_name_or_id(name_or_id)
      if (!@page)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      @page.delete
      flash[:info] = "Page deleted."
      redirect '/wiki'
    end
    
    ## IMPORTANT!!!!!!!!!!
    ## Make sure this route is always at the end of the file.
    
    get '/wiki/:page/?' do |name_or_id|
      if (name_or_id =~ / /)
        redirect "/wiki/#{name_or_id.gsub(' ', '-').downcase}"
      end
      
      @page = WikiPage.find_by_name_or_id(name_or_id)
      
      if (!@page)
        flash[:info] = "Page not found.  Do you want to create it?"
        redirect "/wiki/create?name=#{name_or_id}"
      end
            
      @page_title = "#{@page.heading} - #{game_name}"
      
      dynamic_page = Website::WikiMarkdownExtensions.is_dynamic_page?(@page.text)
                  
      # Update cached version.      
      if (@page.html && !dynamic_page)
        @page_html = @page.html
      else
        @page_html = format_markdown_for_html @page.text
        @page.update(html: @page_html)
      end
            
      erb :"wiki/page"
    end
  end
end
