class File
  def self.parse(file)
    Html.new file.read
  end
end
