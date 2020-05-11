# @engineinternal true
class MarkdownToMURenderer < Redcarpet::Render::Base
  # Methods where the first argument is the text content
  [
    # block-level calls
    :block_quote,
    :block_html, :list,

    # span-level calls
    :autolink, :codespan,  :underline, :raw_html,
    :strikethrough,
    :superscript, 

    # footnotes
    :footnotes, :footnote_def, :footnote_ref,

    # low level rendering
    :entity, :normal_text
  ].each do |method|
    define_method method do |*args|
      args.first
    end
  end
  
  def block_code(content, language)
    text = ""
    content.split("\n").each do |line|
      text << "\n    #{line}"
    end
    text + "\n"
  end
  
  def codespan(code)
    "%xc#{code}%xn"
  end

  def block_quote(text)
    block_code(text, nil)
  end
  
  def list(content, list_type)
    @order = 1
    "\n#{content}"
  end
  
  def list_item(content, list_type)
    if list_type == :ordered
      @order = (@order || 1)
      text = "#{@order}. #{content}"
      @order = @order + 1
    else
      text = "* #{content}"
    end
    text
  end
  
  def underscore(content)
    "unders#{content}zz"    
  end
  
  def highlight(content)
    "%xh#{content}%xn"    
  end

  def triple_emphasis(content)
    "%xh#{content}%xn"    
  end
  
  def double_emphasis(content)
    "%xg#{content}%xn"
  end
  
  def emphasis(content)
    "%xh#{content}%xn"
  end

  # Other methods where we don't return only a specific argument
  def link(link, title, content)
    if link.start_with?("/")
      link = "#{AresMUSH::Game.web_portal_url}#{link}"
    end
    "%xh%xc#{content} (#{link})%xn"
  end

  def image(link, title, content)
    content &&= content + " "
    "#{content} (#{link})"
  end

  def paragraph(text)
    "\n" + text + "\n"
  end

  def header(text, header_level)
    line = "-" * (text.length)
    divider = header_level < 3 ? "\n#{line}\n" : ""
    "\n%xh#{text}%xn#{divider}"
  end

  def hrule()
    "\n" + "-" * 78 + "\n"
  end
  
  def table(header, body)
    "\n#{header}#{body}"
  end

  def table_row(content)
    content + "\n"
  end

  def table_cell(content, alignment)
    content + "\t"
  end
end



class MarkdownFormatter
  def initialize
    options = {
            tables: true,
            no_intra_emphasis: true,
            autolink: true,
            fenced_code_blocks: true
        }

    renderer = MarkdownToMURenderer.new
    @engine = Redcarpet::Markdown.new(renderer, options)
  end
  
  def to_mush(markdown)
    return "" if !markdown
    @engine.render markdown
  end
end