module AresMUSH

  module Demographics
    class DemographicsListCmd
      include CommandHandler
      
      def handle        
        list = []
        all_help = Global.read_config("demographics", "help_text") || {}
        enabled_after_cg = Global.read_config("demographics", "editable_properties")

        Demographics.all_demographics.sort.each do |d|
          help = all_help[d]
          editable = "    "
          if (enabled_after_cg.include?(d))
            editable = "(*) "
          end
          name = "%xh#{d.titleize}#{editable}%xn"
          
          if (!help)
            help = "%xc#{d} <value>%xn"
          end
          list << "#{editable}#{help}"
        end
        
        footer = "%ld%R* - #{t('demographics.demographics_ediable')}"
        template = BorderedListTemplate.new(list, t('demographics.demographics_list_header'), footer) 
        client.emit template.render
      end
    end
  end
end
