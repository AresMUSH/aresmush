module AresMUSH
  module Permissions
    class PermissionsListCmd
      include CommandHandler
      def handle
        list = []
        all_help = Global.read_config("permissions", "permissions") || {}

        Permissions.permissions.sort.each do |d|
          help = all_help[d]
          editable = "    "
          name = "%xh#{d.titleize}#{editable}%xn"

          if (!help)
            help = "%xc#{d} <value>%xn"
          end
          list << "#{editable}#{help}"
        end

        footer = "%ld%R* - #{t('demographics.demographics_ediable')}"
        template = BorderedListTemplate.new(list, t('Permissions.permission_title'), footer) 
        client.emit template.render
      end
    end
  end
end
