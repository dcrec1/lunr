When /^I post to '(.*)' with '(.*)'$/ do |path, parameters|
  visit path, :post, parameters
end
