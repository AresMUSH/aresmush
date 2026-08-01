module AresMUSH
  class Character
    # 1:1 — each Character has at most one Pf2eSheet
    reference :pf2e_sheet, "AresMUSH::Pf2eSheet"
  end
end
