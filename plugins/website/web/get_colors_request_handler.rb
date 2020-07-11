module AresMUSH
  module Website
    class GetColorsRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!Website.can_manage_theme?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        path = File.join(AresMUSH.game_path, "styles", "colors.scss")
        lines = File.readlines(path)
        
        lines.select { |l| !l.blank? }.map { |l| {name: l.before(":").after("$"), value: l.after(":").strip.chomp(";")}}
      end
    end
  end
end