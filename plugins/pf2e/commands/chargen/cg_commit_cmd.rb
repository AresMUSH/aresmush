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

        client.emit_success t('pf2e.cg_commit_ok')
      end
    end
  end
end
