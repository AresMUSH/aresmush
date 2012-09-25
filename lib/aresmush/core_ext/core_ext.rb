String.class_eval do
  def to_ansi
    str = self.gsub(/%cr/, ANSI.red)
    str = str.gsub(/%cn/, ANSI.reset)
    str
  end
end