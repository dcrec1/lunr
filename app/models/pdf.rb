class Pdf
  def to_hash
    { :content => @document.to_text.read }
  end

  private

  def initialize(file)
    @document = PDF::Toolkit.open(file)
  end
end
