module AresMUSH
  module Pf2e
    class CgCommitCmd
      include CommandHandler

      def handle
        result = Pf2e.cg_commit_identity(enactor)
        if !result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        wealth = result[:starting_wealth]
        if wealth
          client.emit_success t('pf2e.cg_commit_ok',
                               :wealth => wealth[:display],
                               :where => wealth[:destination])
        else
          client.emit_success t('pf2e.cg_commit_ok',
                               :wealth => '0 cp',
                               :where => 'society')
        end
      end
    end
  end
end
