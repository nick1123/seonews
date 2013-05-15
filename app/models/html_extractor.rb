class HtmlExtractor
  def title(html_content)
    html_content.scan(/<title>(.*?)</im).flatten[0].to_s.gsub(/\s+/, ' ').to_s.strip
  end
end
