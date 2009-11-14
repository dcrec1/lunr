class Attribute
  def self.field(name, value)
    org.apache.lucene.index.Term.new name.to_s, value.to_s.downcase
  end
end
