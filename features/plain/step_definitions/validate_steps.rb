Then /^a new document with '(.*)' equal to '(.*)' should be created$/ do |attribute, value|
  @document = Document.search(attribute => value).first
  @document.should_not be_nil
end

Then /^the '(.*)' of the document should equal to '(.*)'$/ do |attribute, value|
  @document.send(attribute).should eql(value)
end

Then /^I should get a JSON object with '(.*)' equal to '(.*)'$/ do |attribute, value|
  ActiveSupport::JSON.decode(response.body)[attribute].should eql(value)
end

Then /^I should get a JSON object for this documents:$/ do |table|
  ActiveSupport::JSON.decode(response.body)['documents'].each_with_index do |attributes, i|
    attributes['id'].should eql(table.hashes[i]['id'])
  end
end

Then /^I should see this documents:$/ do |table|
  table.rows.each do |row|
    response.body.should contain(row.first)
  end
end