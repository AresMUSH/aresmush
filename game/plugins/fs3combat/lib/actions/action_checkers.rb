module AresMUSH
  module FS3Combat
    module ActionOnlyAllowsSingleTarget
      def check_only_one_target
        return t('fs3combat.only_one_target') if self.target_names.count > 1
        return nil
      end
    end
  end
end