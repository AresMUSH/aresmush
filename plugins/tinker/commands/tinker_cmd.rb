module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      attr_accessor :role


      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def parse_args
        self.role = titlecase_arg(cmd.args)
      end


      def handle
        client.emit "---------------CREATURES----------"
        client.emit "---------------Major School----------"
        Creature.all.each do |p|
          client.emit "#{p.name}: #{p.major_school['name']}"
          p.update(major_school: "#{p.major_school['name']}")
        end
        client.emit "---------------Minor School----------"
        Creature.all.each do |p|
          client.emit "#{p.name}: #{p.minor_school['name']}"
          p.update(minor_school: "#{p.minor_school['name']}")
        end

        client.emit "---------------PORTALS----------"
        client.emit "---------------Primary School----------"
        Portal.all.each do |p|
          client.emit "#{p.name}: #{p.primary_school['name']}"
          p.update(primary_school: "#{p.primary_school['name']}")
        end
        client.emit "--------------All Schools----------"
        Portal.all.each do |p|
          schools = p.all_schools
          all_schools = []
          schools.each do |s|
            all_schools.concat [s['name']]
          end
          client.emit "#{p.name}: #{all_schools}"
          p.update(all_schools: all_schools)

        end


      end



    end
  end
end
