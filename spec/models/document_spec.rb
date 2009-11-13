require 'spec_helper'

describe Document do
  it "should be initialized without parameters" do
    lambda { Document.new }.should_not raise_error
  end

  context "in a Lucene index" do
    before :each do
      clean_index
    end

    it "should be saved" do
      title = "ruby programming"
      document = Document.new(:title => title).save
      search(:title => "programming").first.get_field("title").string_value.should eql(title)
    end

    it "should be found by :attribute => 'value'" do
      name = "search lucene"
      save :name => name
      Document.search(:name => "lucene").first.name.should eql(name)
    end

    it "should be created" do
      description = "this is a little story"
      document = Document.create! :description => description
      search(:description => "story").first.get_field("description").string_value.should eql(description)
    end

    it "should save multiple documents in an index" do
      Document.create! :name => "Kate Moss"
      Document.create! :name => "Kate Perry"
      search(:name => "kate").size.should == 2
    end

    it "should find multiple documents" do
      save :place => "Rio de Janeiro"
      save :place => "Rio Amazonas"
      Document.search(:place => "rio").last.place.should eql("Rio Amazonas")
    end

    it "should find a document by a query like 'query'" do
      country = "Brazil"
      Document.create! :country => country
      Document.search("brazil").first.country.should eql(country)
    end

    it "should find multiple documents by a query like 'query'" do
      Document.create! :country => "Turkey"
      Document.create! :animal => "Turkey"
      Document.search("turkey").last.animal.should eql("Turkey")
    end

    it "should be updated if has an id" do
      Document.create!(:id => "15", :city => "Rome").update_attributes(:city => "London")
      Document.search("london").size.should == 1
    end

    it "should be saved with multiple fields" do
      Document.create! :param1 => "value1", :param2 => "value2"
      Document.search("value").size.should == 1
    end

    xit "should be destroyed if has id" do
      Document.create!(:id => "5", :dream => "sky").destroy
      Document.search("sky").should be_empty
    end
  end
end
