class MatchData
  def names_hash
    name_hash = {}
    names.each { |n| name_hash[n.to_sym] = self[n] }
    name_hash
  end  
end