require 'spec_helper'

describe Document do
  before :each do
    clean_index
  end

  context "in a Lucene index" do
    it "should be saved" do
      title = "ruby programming"
      document = Document.new(:title => title).save
      search(:title => "programming").first.get_field("title").string_value.should eql(title)
    end

    it "should be found by :attribute => 'value'" do
      name = "search lucene"
      save(:name => name)
      Document.search(:name => "lucene").first.name.should eql(name)
    end

    it "should be created" do
      description = "this is a little story"
      document = Document.create! :description => description
      search(:description => "story").first.get_field("description").string_value.should eql(description)
    end

    it "should find multiple documents by :attribute => 'value'" do
      Document.create! :name => "Kate Moss"
      Document.create! :name => "Kate Perry"
      search(:name => "kate").size.should == 2
    end
  end
end
