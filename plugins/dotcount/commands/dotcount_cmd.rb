module AresMUSH
  module Dotcount
    class DotcountCmd
      include CommandHandler
 
      attr_accessor :name
 
      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end
 
      def handle
          result = Dotcount.calculate_dots(self.name, client, enactor)
          if result 
          pad_xp = (result["max_xp"] > 9 && result["current_xp"] < 10) ? '.' : ''
          note = result["poor_attr"] ? t('dotcount.poor_note_client') : ''
          msg = t('dotcount.result_client', :name => self.name, :spent_attrs => result["spent_attrs"], :spent_action => result["spent_action"], :max_attrs => result["max_attrs"], :max_action => result["max_action"], :max_xp => result["max_xp"], :current_xp => result["current_xp"].to_s, :pad_xp => pad_xp, :note => note )
          template = BorderedDisplayTemplate.new msg
          client.emit template.render
        else
          client.emit_failure t('dotcount.no_sheet', :name => self.name)
        end  
     end
    end
  end  
end