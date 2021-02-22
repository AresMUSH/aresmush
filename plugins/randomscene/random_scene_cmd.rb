module AresMUSH
  module Randomscene
    class RandomSceneCmd
    # shield/off <shield>
      include CommandHandler

      attr_accessor :names, :area

      def parse_args
        if cmd.args
          args = cmd.parse_args(ArgParser.arg1_slash_optional_arg2)
          names = list_arg(args.arg1)
          self.names = names.concat [enactor.name]
          self.area = titlecase_arg(args.arg2)
        else
          self.names = [enactor.name]
        end
      end

      def check_errors
        is_area = Area.find_one_by_name(self.area)
        return t('rooms.area_not_found') if (self.area && !is_area)
      end

      def handle
        self.names.each do |name|
          char = Character.find_one_by_name(name)
          if (!char)
            client.emit_failure t('page.invalid_name')
            return
          end
        end

        excluded_areas = Global.read_config("randomscene", "excluded_areas")
        all_excluded_areas = []
        Area.all.each do |area|
          excluded_areas.each do |excluded_area_name|
            excluded_area = Area.find_one_by_name(excluded_area_name)
            if Rooms.has_parent_area(area, excluded_area)
              all_excluded_areas.concat [area.name]
              all_excluded_areas  = all_excluded_areas.uniq
            end
          end
          all_excluded_areas.concat excluded_areas
        end
        if self.area
          room_list = Room.all.select { |r| (r.room_type == "IC" && r.area && r.area_name == self.area) }
        else
          room_list = Room.all.select { |r| (r.room_type == "IC" && r.area && !all_excluded_areas.include?(r.area_name)) }
        end
        room = room_list.sample

        type = rand(2)
        if type == 0
          scenario = Global.read_config("randomscene", "scenarios")
          msg = t('randomscene.random_scenario', :scenario => scenario.sample, :area => room.area.name, :room => room.name)
        elsif type == 1
          word_list = Global.read_config("randomscene", "words")
          prompts = ""
          self.names.each do |name|
            prompts = prompts + t('randomscene.prompt_piece', :name => name.titlecase, :word =>  word_list.sample)
          end
          msg = t('randomscene.prompt_total', :prompts => prompts, :area => room.area.name, :room => room.name)
        elsif type == 2
          npc_list = Global.read_config("randomscene", "npcs")
          action_list = Global.read_config("randomscene", "actions")
          msg = t('randomscene.npc_scenario', :npc => npc_list.sample, :action => action_list.sample, :area => room.area.name, :room => room.name)
        end
        self.names.each do |name|
          char = Character.named(name)
          Login.emit_if_logged_in(char, msg)
        end

      end

    end
  end
end
