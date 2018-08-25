module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end





      def handle
        char_name = cmd.args
        char = Character.find_one_by_name(char_name)
        client.emit char
        skills = {}
        # FS3Skills.attrs.map { |a| a['name'] }.each do |a|
        #   skills[a] = 1
        # end
        #
        # FS3Skills.action_skills.map { |a| a['name'] }.each do |a|
        #   skills[a] = Global.read_config('fs3skills', 'allow_unskilled_action_skills') ? 0 : 1
        # end
        #
        # groups = get_groups_for_char(char)
        # groups.each do |k, v|
        #   group_skills = v["skills"]
        #   next if !group_skills
        #   group_skills.each do |skill, rating|
        #     if (!skills.has_key?(skill) || skills[skill] < rating)
        #       skills[skill] = rating
        #     end
        #   end
        # end




        review = FS3Skills.starting_skills_check(char)
        client.emit review


      end



    end
  end
end
