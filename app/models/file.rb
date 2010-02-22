class File
  def self.parse(file)
    File.extname(file.path).gsub('.', '').classify.constantize.new file
  end
end
