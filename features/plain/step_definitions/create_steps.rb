Given /^I have no documents$/ do
  system "rm -Rf #{Index::PATH}"
end

Given /^a document exists with '(.*)' equal to '(.*)'$/ do |attribute, value|
  Document.create! attribute => value
end
