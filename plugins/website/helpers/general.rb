module AresMUSH
  module Website
    mattr_accessor :emoji_regex
    
    def self.is_restricted_wiki_page?(page)
      restricted_pages = Global.read_config("website", "restricted_pages") || ['home']
      restricted_pages.each do |p|
        if (p =~ /.+\:\*/) 
          category = WikiPage.sanitize_page_name(p.before(':'))
          return true if category == page.category
        else
          restrict = WikiPage.sanitize_page_name(p)
          return true if restrict == page.name
        end
      end
      false
    end
    
    def self.can_manage_wiki?(actor)
      actor && actor.has_permission?("manage_wiki")
    end
    
    def self.can_manage_textfile?(enactor, file_type)
      case file_type
      when "text"
        Website.can_manage_theme?(enactor) || Manage.can_manage_game?(enactor)
      when "style"
        Website.can_manage_theme?(enactor)
      when "config"
        Manage.can_manage_game?(enactor)
      when "code"
        enactor.is_coder?
      else
        false
      end
    end
    
    def self.check_login(request, allow_anonymous = false)
      return nil if allow_anonymous
      return { error: "You need to log in first." } if !request.enactor
      token = request.auth[:token]
      if !request.enactor.is_valid_api_token?(token)
        return { error: t('webportal.session_expired') } 
      end
      if !Website.is_valid_api_key?(request.enactor, request.api_key)
        return { error: t('webportal.invalid_api_key') } 
      end
      return nil
    end
    
    def self.is_valid_api_key?(enactor, api_key)
      return true if Website.engine_api_keys.include?(api_key)
      player_key = Game.master.player_api_keys[api_key]
      return false if !player_key
      player_key == enactor.id.to_s
    end
    
    def self.get_file_info(file_path)
      return nil if !file_path
      relative_path = file_path.gsub(AresMUSH.website_uploads_path, '')
      folder = File.dirname(relative_path).gsub(AresMUSH.website_uploads_path, '').gsub('/', '')
      name = File.basename(relative_path)
      file_meta = WikiFileMeta.find_meta(folder, name)
      description = (file_meta && file_meta.description) ? file_meta.description : '' 
      
      {
        path: relative_path,
        name: name,
        folder: folder.blank? ? '/' : folder,
        description: description,
        title: description.blank? ? '' : description
      }
    end
    
    
    def self.rebuild_css
      engine_styles_path = File.join(AresMUSH.engine_path, 'styles')
      scss_path = File.join(engine_styles_path, 'ares.scss')
      css_path = File.join(AresMUSH.website_styles_path, 'ares.css')
      load_paths = [ engine_styles_path, AresMUSH.website_styles_path ]
      css = SassC::Engine.new(File.read(scss_path), { load_paths: load_paths }).render
      File.open(css_path, "wb") {|f| f.write(css) }
    end
    
    def self.deploy_portal(client = nil)
      Website.redeploy_portal(nil, false)
    end
    
    def self.redeploy_portal(enactor, from_web)
      Global.dispatcher.spawn("Deploying website", nil) do
        Website.rebuild_css
        install_path = Global.read_config('website', 'website_code_path')
        Dir.chdir(install_path) do

          output = `bin/deploy 2>&1`
          Global.logger.info "Deployed web portal: #{output}"
          message = t('webportal.portal_deployed', :output => output)
          if (from_web)
            Global.client_monitor.notify_web_clients(:manage_activity, Website.format_markdown_for_html(message), false) do |c|
               c && c == enactor
            end
          elsif (enactor) # Enactor should always be specified except in the backwards-compatibility example.
            Login.emit_ooc_if_logged_in enactor, message
          end
        end
      end
    end
    
    def self.welcome_text
      text = Global.config_reader.get_text('website.txt')
      Website.format_markdown_for_html(text)
    end
    
    def self.engine_api_keys
      Global.read_config("secrets", "engine_api_keys") || []
    end
    
    def self.can_edit_wiki_file?(actor, folder)
      return false if !actor
      return true if Website.can_manage_wiki?(actor)
      return true if folder.downcase == FilenameSanitizer.sanitize(actor.name)
      return true if ((folder.downcase == "theme_images") && Website.can_manage_theme?(actor))
      return false
    end
    
    def self.folder_size_kb(folder)
      files = Dir["#{folder}/*"].select { |f| File.file?(f) }
      files.sum { |f| File.size(f) } / 1024
    end
    
    def self.webportal_version
      install_path = Global.read_config('website', 'website_code_path')
      version_path = File.join(install_path, 'public', 'scripts', 'aresweb_version.js')
      version = File.read(version_path)
      version = version.gsub('var aresweb_version = "', '').gsub('";', '').chomp
    end
    
    def self.wiki_templates
      templates = WikiPage.all.select { |p| p.category == "template" }.map { |p| {
        title: p.title.gsub("template:", ""),
        name: p.name.gsub("template:", ""),
        text: p.text
      }
      }
      templates << { title: 'blank', name: 'blank', text: '' }
      templates
    end
    
    def self.get_emoji_regex
      if (!Website.emoji_regex)
        Website.emoji_regex = EmojiFormatter.emoji_regex
      end
      Website.emoji_regex
    end
    
    def self.export_wiki(client = nil)
      Global.dispatcher.spawn("Performing wiki export.", client) do
        Global.logger.debug "Exporting wiki."
        error = AresMUSH::Website::WikiExporter.export
        if (error)
          Global.logger.error "Error performing wiki export: #{error}"
          if (client)
            client.emit_failure t('webportal.wiki_export_error')
          end
        else
          Global.logger.debug "Wiki export successful."
          if (client)
            client.emit_success t('webportal.wiki_export_success')
          end
        end
      end
    end
    
    def self.find_code_file_path(search_name)
      Website.editable_code_files.each do |section|
        section[:files].each do |name, path|
          if (name == search_name)
            return path
          end
        end
      end
      raise "File #{search_name} not found in editable file list."
    end    
    
    def self.editable_code_files
      web_code_path = File.join(AresMUSH.website_code_path, 'app')
      plugin_code_path = AresMUSH.plugin_path
      
      [
        {
          name: "Profile Display",
          help: "https://aresmush.com/tutorials/code/hooks/char-fields.html",
          files: {
            'profile-custom-tabs.hbs' => File.join(web_code_path, 'templates', 'components', 'profile-custom-tabs.hbs'),  
            'profile-custom.hbs' => File.join(web_code_path, 'templates', 'components', 'profile-custom.hbs'),  
            'profile-custom.js' => File.join(web_code_path, 'components', 'profile-custom.js'),
            'custom_char_fields.rb' => File.join(plugin_code_path, 'profile', 'custom_char_fields.rb'),
          }
        },

        {
          name: "Profile Editing",
          help: "https://aresmush.com/tutorials/code/hooks/char-fields.html",
          files: {
            'char-edit-custom-tabs.hbs' => File.join(web_code_path, 'templates', 'components', 'char-edit-custom-tabs.hbs'),
            'char-edit-custom.hbs' => File.join(web_code_path, 'templates', 'components', 'char-edit-custom.hbs'),
            'char-edit-custom.js' => File.join(web_code_path, 'components', 'char-edit-custom.js'),
            'custom_char_fields.rb' => File.join(plugin_code_path, 'profile', 'custom_char_fields.rb'),
          }
        },

        
        {
          name: "Chargen",
          help: "https://aresmush.com/tutorials/code/hooks/char-fields.html",
          files: {
            'chargen-custom.hbs' => File.join(web_code_path, 'templates', 'components', 'chargen-custom.hbs'),  
            'chargen-custom-tabs.hbs' => File.join(web_code_path, 'templates', 'components', 'chargen-custom-tabs.hbs'),  
            'chargen-custom.js' => File.join(web_code_path, 'components', 'chargen-custom.js'),
            'custom_char_fields.rb' => File.join(plugin_code_path, 'profile', 'custom_char_fields.rb'),
          }
        },
        
        {
          name: "Chargen App Review",
          help: "https://aresmush.com/tutorials/code/hooks/app-review.html",
          files: {
            'custom_app_review.rb' => File.join(plugin_code_path, 'chargen', 'custom_app_review.rb'),
          }
        },
        
        {
          name: "Chargen Approval Triggers",
          help: "https://aresmush.com/tutorials/code/hooks/approval-triggers.html",
          files: {
            'custom_approval.rb' => File.join(plugin_code_path, 'chargen', 'custom_approval.rb'),
          }
        },
        
        {
          name: "Scene Actions",
          help: "https://aresmush.com/tutorials/code/hooks/scene-buttons.html",
          files: {
            'live-scene-custom-play.hbs' => File.join(web_code_path, 'templates', 'components', 'live-scene-custom-play.hbs'),  
            'live-scene-custom-play.js' => File.join(web_code_path, 'components', 'live-scene-custom-play.js'),
            'live-scene-custom-scenepose.hbs' => File.join(web_code_path, 'templates', 'components', 'live-scene-custom-scenepose.hbs'),  
            'live-scene-custom-scenepose.js' => File.join(web_code_path, 'components', 'live-scene-custom-scenepose.js'),
            'custom_scene_data.rb' => File.join(plugin_code_path, 'scenes', 'custom_scene_data.rb'),
            
          }
        },
        
        {
          name: "Scene Character Cards",
          help: "https://aresmush.com/tutorials/code/hooks/char-cards.html",
          files: {
            'char-card-custom.hbs' => File.join(web_code_path, 'templates', 'components', 'char-card-custom.hbs'),  
            'char-card-custom.js' => File.join(web_code_path, 'components', 'char-card-custom.js'),
            'custom_char_card.rb' => File.join(plugin_code_path, 'scenes', 'custom_char_card.rb'),
          }
        },
        
        {
          name: "Combat Actions",
          help: "https://aresmush.com/tutorials/code/hooks/fs3-actions.html",
          files: {
            'custom_hooks.rb' => File.join(plugin_code_path, 'fs3combat', 'custom_hooks.rb'),
            }
        },
        
        {
          name: "Combat New Turn Triggers",
          help: "https://aresmush.com/tutorials/code/hooks/fs3-new-turn.html",
          files: {
            'custom_hooks.rb' => File.join(plugin_code_path, 'fs3combat', 'custom_hooks.rb'),
          }
        },
        
        {
          name: "Job Actions",
          help: "https://aresmush.com/tutorials/code/hooks/job-menu.html",
          files: {
            'job-menu-custom.hbs' => File.join(web_code_path, 'templates', 'components', 'job-menu-custom.hbs'),  
            'job-menu-custom.js' => File.join(web_code_path, 'components', 'job-menu-custom.js'),
            'custom_job_data.rb' => File.join(plugin_code_path, 'jobs', 'custom_job_data.rb'),
            
          }
        },
        
      ]
    end
    
    def self.build_top_navbar(viewer)
      navbar = Global.read_config('website', 'top_navbar')
      navbar.select { |n| !n['roles'] || (viewer && viewer.has_any_role?(n['roles'])) }
    end
      
  end
end
