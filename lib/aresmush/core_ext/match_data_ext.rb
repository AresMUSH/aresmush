class MatchData
  def names_hash
    name_hash = {}
    names.each { |n| name_hash[n] = self[n] }
    name_hash
  end  
end