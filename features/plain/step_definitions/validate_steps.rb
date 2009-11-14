Then /^a new document with '(.*)' equal to '(.*)' should be created$/ do |attribute, value|
  @document = Document.search(attribute => value).first
  @document.should_not be_nil
end

Then /^the '(.*)' of the document should equal to '(.*)'$/ do |attribute, value|
  @document.send(attribute).should eql(value)
end
