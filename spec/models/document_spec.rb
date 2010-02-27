require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Document do
  it { subject.class.superclass.should eql(ActiveLucene::Document) }
end
