Given /^I have no documents$/ do
  system "rm -Rf #{ActiveLucene::Index::PATH}"
end

Given /^a document exists with '(.*)' equal to '(.*)'$/ do |attribute, value|
  Document.create! attribute => value
end

Given /^I have this documents:$/ do |table|
  table.hashes.each do |params|
    Document.create! params
  end
end
