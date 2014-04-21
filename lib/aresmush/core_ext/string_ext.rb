class String
    
  def first(sep)
    parts = self.partition(sep)  # Returns [head, sep, tail]
    return parts[0]
  end

  def rest(sep)
    parts = self.partition(sep)        # Returns [head, sep, tail]
    return parts[0] if parts[1] == ""  # sep empty if not found
    return parts[2]
  end
  
  def after(sep)
    self.rest(sep)  # Just an alias
  end
  
  # Fairly crude - doesn't worry about helper words or anything.  Should suffice for MUSH purposes.
  def titlecase
    self.gsub(/\b('?[a-z])/) { $1.capitalize }
  end   
  
  def titleize
    self.downcase.strip.titlecase
  end    
  
  def code_gsub(find, replace)
    str = self
    
    # Ugly regex to find/replace special codes.  Will replace the 'find' value (example, %r), 
    # except when escaped (\%r) 
    str.gsub(/
    (?<!\\)           # Not preceded by a single backslash
    (#{find})
    /x, 
      
    "#{replace}")  
  end    
  
  def truncate(length)
    self[0..length - 1]    
  end  
  
  # From ActiveRecord
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end 
end