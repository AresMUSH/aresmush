module AresMUSH
  module EventHandlers
    class Create
      def initialize(container)
      end

      def commands
        ["create (?<name>\\S+) (?<password>\\S+)"]
      end

      def on_player_command(client, cmd)
        name = cmd[:name]
        password = cmd[:password]

        existing_player = db[:players].where(:name => name)
        if (!existing_player.empty?)
          client.emit_failure(t('login.player_name_taken'))
        else
          # TODO: Encrypt password
          # TODO: Specs
          db.transaction do
             dbref = Dbref.create(:type => :player)
             player = Player.new
             player.name = name
             player.password = password
             player.dbref = dbref
             player.save
          end
          client.emit_success(t('login.player_created', :name => name))
        end
      end
    end
  end
end
