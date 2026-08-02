module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Currency
    # Denominations: pp, gp, sp, cp (1 pp = 10 gp = 100 sp = 1000 cp)
    # money           — purse (on person)
    # society_account — Hall ledger (PC-owned, not coin, not encumbrance)
    # -------------------------------------------------

    COIN_KEYS = %w[pp gp sp cp].freeze
    COIN_TO_CP = {
      "pp" => 1000,
      "gp" => 100,
      "sp" => 10,
      "cp" => 1
    }.freeze

    def self.coin_key(name)
      k = name.to_s.strip.downcase
      return k if COIN_KEYS.include?(k)
      case k
      when "platinum", "plat" then "pp"
      when "gold" then "gp"
      when "silver" then "sp"
      when "copper", "copperpiece", "copperpieces" then "cp"
      else nil
      end
    end

    def self.empty_purse
      { "pp" => 0, "gp" => 0, "sp" => 0, "cp" => 0 }
    end

    def self.normalize_purse(hash)
      out = empty_purse
      return out unless hash.is_a?(Hash)
      COIN_KEYS.each do |k|
        out[k] = [hash[k].to_i, 0].max
      end
      out
    end

    def self.purse_to_cp(hash)
      p = normalize_purse(hash)
      COIN_KEYS.sum { |k| p[k] * COIN_TO_CP[k] }
    end

    # Convert copper pieces to a normalized purse (largest denominations first).
    def self.cp_to_purse(total_cp)
      total = [total_cp.to_i, 0].max
      pp = total / 1000
      total %= 1000
      gp = total / 100
      total %= 100
      sp = total / 10
      cp = total % 10
      { "pp" => pp, "gp" => gp, "sp" => sp, "cp" => cp }
    end

    # Display string: omit zero denominations. e.g. "2 gp, 5 sp"
    def self.format_money(hash)
      p = normalize_purse(hash)
      parts = COIN_KEYS.map { |k| p[k] > 0 ? "#{p[k]} #{k}" : nil }.compact
      parts.empty? ? "0 cp" : parts.join(", ")
    end

    def self.sheet_money(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return empty_purse unless sheet
      normalize_purse(sheet.money)
    end

    def self.sheet_society_account(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return empty_purse unless sheet
      normalize_purse(sheet.society_account)
    end

    def self.set_money(char_or_sheet, purse)
      sheet = sheet_for(char_or_sheet)
      return nil unless sheet
      sheet.update(money: normalize_purse(purse))
      sheet_money(sheet)
    end

    def self.set_society_account(char_or_sheet, purse)
      sheet = sheet_for(char_or_sheet)
      return nil unless sheet
      sheet.update(society_account: normalize_purse(purse))
      sheet_society_account(sheet)
    end

    # Add coins to purse (positive) or remove (negative amounts in delta hash).
    # Returns { ok:, error:, money: } — fails if resulting any denomination would go negative
    # unless allow_negative (internal use only).
    def self.adjust_money(char_or_sheet, delta, allow_negative: false)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      current = sheet_money(sheet)
      delta = normalize_purse(delta)
      next_purse = empty_purse
      COIN_KEYS.each do |k|
        next_purse[k] = current[k] + delta[k]
        if next_purse[k] < 0 && !allow_negative
          return { ok: false, error: "pf2e.money_insufficient", money: current }
        end
      end
      sheet.update(money: next_purse)
      { ok: true, error: nil, money: next_purse }
    end

    def self.adjust_society_account(char_or_sheet, delta, allow_negative: false)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      current = sheet_society_account(sheet)
      delta = normalize_purse(delta)
      next_purse = empty_purse
      COIN_KEYS.each do |k|
        next_purse[k] = current[k] + delta[k]
        if next_purse[k] < 0 && !allow_negative
          return { ok: false, error: "pf2e.society_insufficient", society_account: current }
        end
      end
      sheet.update(society_account: next_purse)
      { ok: true, error: nil, society_account: next_purse }
    end

    # Spend from purse by total value in cp (auto-makes change across denominations).
    def self.spend_cp(char_or_sheet, cost_cp)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet
      cost = cost_cp.to_i
      return { ok: false, error: "pf2e.money_bad_amount" } if cost < 0

      have = purse_to_cp(sheet_money(sheet))
      return { ok: false, error: "pf2e.money_insufficient", money: sheet_money(sheet) } if have < cost

      set_money(sheet, cp_to_purse(have - cost))
      { ok: true, error: nil, money: sheet_money(sheet), spent_cp: cost }
    end

    # Deposit purse coins into Society account (must have the coins on person).
    def self.society_deposit(char_or_sheet, amount_hash)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      amount = normalize_purse(amount_hash)
      if COIN_KEYS.all? { |k| amount[k] == 0 }
        return { ok: false, error: "pf2e.money_bad_amount" }
      end

      take = adjust_money(sheet, COIN_KEYS.each_with_object({}) { |k, h| h[k] = -amount[k] })
      return take unless take[:ok]

      put = adjust_society_account(sheet, amount)
      unless put[:ok]
        # rollback purse
        adjust_money(sheet, amount)
        return put
      end

      {
        ok: true,
        error: nil,
        money: sheet_money(sheet),
        society_account: sheet_society_account(sheet),
        deposited: amount
      }
    end

    # Withdraw from Society account into purse (converts ledger → coin for spending).
    def self.society_withdraw(char_or_sheet, amount_hash)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      amount = normalize_purse(amount_hash)
      if COIN_KEYS.all? { |k| amount[k] == 0 }
        return { ok: false, error: "pf2e.money_bad_amount" }
      end

      take = adjust_society_account(sheet, COIN_KEYS.each_with_object({}) { |k, h| h[k] = -amount[k] })
      return take unless take[:ok]

      put = adjust_money(sheet, amount)
      unless put[:ok]
        adjust_society_account(sheet, amount)
        return put
      end

      {
        ok: true,
        error: nil,
        money: sheet_money(sheet),
        society_account: sheet_society_account(sheet),
        withdrawn: amount
      }
    end

    # Coin count for encumbrance (1000 coins = 1 Bulk). Society account excluded.
    def self.coin_count(char_or_sheet)
      p = sheet_money(char_or_sheet)
      COIN_KEYS.sum { |k| p[k] }
    end

  end
end
