module AresMUSH
  module Website
    
    def self.is_restricted_wiki_page?(page)
      restricted_pages = Global.read_config("website", "restricted_pages") || ['home']
      restricted_pages.map { |p| WikiPage.sanitize_page_name(p.downcase) }.include?(page.name.downcase)
    end
    
    def self.can_manage_wiki?(actor)
      actor && actor.has_permission?("manage_wiki")
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
      {
        path: relative_path,
        name: File.basename(relative_path),
        folder: File.dirname(relative_path).gsub(AresMUSH.website_uploads_path, '').gsub('/', '')
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
            Global.client_monitor.notify_web_clients(:manage_activity, Website.format_markdown_for_html(message)) do |c|
               c && c == enactor
            end
          elsif (enactor) # Enactor should always be specified except in the backwards-compatibility example.
            Login.emit_ooc_if_logged_in enactor, message
          end
        end
      end
    end
    
    def self.welcome_text
      welcome_filename = File.join(AresMUSH.game_path, "text", "website.txt")
      text = File.read(welcome_filename, :encoding => "UTF-8")
      Website.format_markdown_for_html(text)
    end
    
    def self.engine_api_keys
      Global.read_config("secrets", "engine_api_keys") || []
    end
    
    def self.can_edit_wiki_file?(actor, folder)
      return false if !actor
      wiki_admin = Website.can_manage_wiki?(actor)
      own_folder = folder.upcase == actor.name_upcase
      wiki_admin || own_folder
    end
    
    def self.folder_size_kb(folder)
      files = Dir["#{folder}/*"].select { |f| File.file?(f) }
      files.sum { |f| File.size(f) } / 1000
    end
    
    def self.webportal_version
      install_path = Global.read_config('website', 'website_code_path')
      version_path = File.join(install_path, 'public', 'scripts', 'aresweb_version.js')
      version = File.read(version_path)
      version = version.gsub('var aresweb_version = "', '').gsub('";', '').chomp
    end
  end
end
