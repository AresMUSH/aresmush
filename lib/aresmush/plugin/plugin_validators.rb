module AresMUSH
    
  module CommandWithoutArgs
    # Make sure this runs before other validators except login - hence the '2' in the name.
    def check_2_no_args
      return t('dispatcher.cmd_no_args') if cmd.args
      return nil
    end
  end
end