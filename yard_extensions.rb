class OhmAttrHandler < YARD::Handlers::Ruby::AttributeHandler
  handles method_call(:attribute)
  namespace_only

  process do
    name = statement.parameters.first.jump(:tstring_content, :ident).source
    
    o = MethodObject.new(namespace, name, scope)
    
    o.explicit = true
    if (statement.source =~ /DataType\:\:([^\,]+)/)
      #o.add_tag(YARD::Tags::Tag.new(:return, statement.source, $1))
      #o.tag(:return).types = [$1]
      attr_type = $1
    else
      #o.add_tag(YARD::Tags::Tag.new(:return, statement.source, String))
      #o.tag(:return).types = ['String']
      attr_type = 'String'
    end

    if (statement.source =~ /default \=\> (.+)/)
      default = $1
    else
      default = attr_type == "Boolean" ? "false" : "nil"
    end
    
    register(o)
    
    
    namespace.attributes[scope][name] ||= SymbolHash[:read => nil, :write => nil]
    namespace.attributes[scope][name][:write] = o
    namespace.attributes[scope][name][:read] = o
        
    summary = "Description: #{o.base_docstring.summary.empty? ? '---' : o.base_docstring.summary }"
    files = o.files.map { |file, line| "#{file} line #{line}" }.join(', ')

    separator = "~~~~~~"

    o.docstring = ["@return [#{attr_type}]", "#{summary} #{separator} Default: #{default} #{separator} Defined In: #{files}", "@api public"]
  end
end