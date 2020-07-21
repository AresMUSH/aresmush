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
      else
        false
      end
    end
    
    def self.check_login(request, allow_anonymous = false)
      return nil if allow_anonymous
      return { error: "You need to log in first." } if !request.enactor
      token = request.auth[:token]
      if request.enactor.is_valid_api_token?(token)
        return nil
      end
      return { error: t('webportal.session_expired') } 
    end
    
    def self.get_file_info(file_path)
      return nil if !file_path
      relative_path = file_path.gsub(AresMUSH.website_uploads_path, '')
      folder = File.dirname(relative_path).gsub(AresMUSH.website_uploads_path, '').gsub('/', '')
      {
        path: relative_path,
        name: File.basename(relative_path),
        folder: folder.blank? ? '/' : folder
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
      wiki_admin = Website.can_manage_wiki?(actor)
      own_folder = folder.downcase == FilenameSanitizer.sanitize(actor.name)
      wiki_admin || own_folder
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
        text: p.text
      }
      }
      templates << { title: 'blank', text: '' }
      templates
    end
    
    def self.get_emoji_regex
      if (!Website.emoji_regex)
        Website.emoji_regex = EmojiFormatter.emoji_regex
      end
      Website.emoji_regex
    end
  end
end
