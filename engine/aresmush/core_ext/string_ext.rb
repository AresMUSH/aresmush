class String
  
  def first(sep)
    parts = self.partition(sep)  # Returns [head, sep, tail]
    return parts[0]
  end

  def rest(sep)
    parts = self.partition(sep)        # Returns [head, sep, tail]
    return "" if parts[1] == ""  # sep empty if not found
    return parts[2]
  end
  
  def before(sep)
    self.first(sep) # Just an alias
  end
  
  def after(sep)
    self.rest(sep)  # Just an alias
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
  
  def is_integer?
    !!(self =~ /^\d+$/)
  end
  
  # From ActiveRecord
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end 
  
  def repeat(n)
    n.times.collect { self }.join
  end

  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
  
end

class Object
  def blank?
    self.to_s.empty?
  end
end