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
    
    get '/wiki/?' do 
      redirect '/wiki/home'
    end
    
    get '/wiki/all/?' do
      @title = "All Pages"
      @pages = WikiPage.all.to_a.sort_by { |p| p.display_title }
      erb :"wiki/all_pages"
    end
    
    get '/wiki/tag/:tag/?' do |tag|
      @tag = tag.titlecase
      @pages = WikiPage.all.select { |p| p.tags.include?(tag.downcase) }.sort_by { |p| p.display_title }
      @chars = Character.all.select { |c| c.profile_tags.include?(tag.downcase) }.sort_by { |c| c.name }
      @scenes = Scene.all.select { |s| s.tags.include?(tag.downcase) }.sort_by { |s| s.date_title }
  
      erb :"wiki/tag"
    end

    get '/wiki/tags/?' do 
      @tags = []
      WikiPage.all.each do |p|
        @tags = @tags.concat p.tags
      end
      Character.all.each do |c|
        @tags = @tags.concat c.profile_tags
      end
      Scene.all.each do |s|
        @tags = @tags.concat s.tags
      end
      
      @tags = @tags.uniq
  
      erb :"wiki/tags"
    end
    
    get '/wiki/recent_changes/?' do
      @recent = Wiki.recent_changes
      
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
      
      @page_title = "#{@page.display_title} - #{game_name}"
            
      erb :"wiki/page_source"
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
            
      @page_title = "#{@page.display_title} - #{game_name}"
      
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
