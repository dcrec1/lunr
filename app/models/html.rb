class Html
  def self.parse(text)
    self.new text.lstrip.start_with?("<") ? text : Net::HTTP.get(URI.parse(text))
  end
  
  def to_hash
    { :head => content_from("head"), :body => content_from("body") }
  end
  
  private
  
  def initialize(text_or_io)
    @document = Nokogiri::HTML(text_or_io)
    @document.search("script").unlink
  end
  
  def content_from(name)
    @document.search(name).first.content
  end
end