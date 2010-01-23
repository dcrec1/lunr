require 'spec_helper'

describe Document do
  it { subject.class.superclass.should eql(ActiveLucene::Document) }
end
