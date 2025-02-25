module ApplicationHelper

def markdown(text)

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, strikethrough: true, fenced_code_blocks: true, no_intra_emphasis: true)

    return markdown.render(text).html_safe

end

end
