module AresMUSH
  class Character
    def has_unread_mail?
      mail.any? { |m| !m.read }
    end
  end
end