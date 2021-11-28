module AresMUSH
  module Login
    class BanListRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        if !enactor.is_admin?
          return { error: t('dispatcher.not_allowed') }
        end

       Game.master.banned_sites.map { |k, v| {
         site: k,
         reason: Website.format_markdown_for_html(v)
       }}
      end
    end
  end
end