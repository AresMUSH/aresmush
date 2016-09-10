module AresMUSH

  module Roster
    class RosterViewCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'roster'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("roster") && cmd.switch.nil? && !cmd.args.nil?
      end

      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          registry = model.roster_registry
          
          if (!registry)
            client.emit_failure t('roster.not_on_roster', :name => model.name)
            return
          end
          
          website = Global.read_config("game", "website")
          
          text = "%xh#{model.name}%xn (#{Demographics::Interface.fullname(model)})"
          text << "%R%R"
          text << "%xh#{t('roster.played_by')}%xn #{Actors::Interface.actor(model)}"
          text << "%R%R"
          text << "%xh#{t('roster.wiki_page')}%xn #{website}/#{model.name}"
          
          if (registry.contact)
            text << "%R%R#{t('roster.contact', :name => registry.contact)}"
          end
          
          text << "%R%R"
          text << t('roster.roster_claim', :name => model.name)
          
          client.emit BorderedDisplay.text text
        end
      end
    end
  end
end
