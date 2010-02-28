require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe DocumentsController do
  should_behave_like_resource :formats => [:html, :json, :xml], :paginate => true

  before :each do
    @mocked_document = mock(Document, :save => true)
  end

  context "responding to POST create" do
    context "with multipart data" do
      before :each do
        request.stub!(:content_type).and_return(Mime::MULTIPART_FORM)
      end

      it "should extract the text of the pdf file attribute and create a document with attribute content" do
        Document.should_receive(:new).with('content' => "Hello from pdf!\n\n\f").and_return(@mocked_document)
        post :create, :file => File.open(File.join(File.dirname(__FILE__),'..','data','index.pdf'))
      end

      it "should extract the text of the html attribute and create a document with attributes head and body, ignoring the script tags" do
        Document.should_receive(:new).with('head' => "HTML Title", 'body' => "This is the body!").and_return(@mocked_document)
        post :create, :file => File.open(File.join(File.dirname(__FILE__),'..','data','index.html'))
      end
    end

    it "should extract the text of the html attribute and create a document with attributes head and body, ignoring the script tags" do
      Document.should_receive(:new).with('html' => html, 'head' => "HTML Title", 'body' => "This is the body!", 'title' => "This page rocks!").and_return(@mocked_document)
      post :create, :document => { :html => html, :title => "This page rocks!" }
    end

    it "should extract the text of the url attribute and create a document with attributes head and body" do
      Document.should_receive(:new).with('url' => url, 'head' => "HTML Title", 'body' => "This is the body!", 'name' => "My blog :)").and_return(@mocked_document)
      post :create, :document => { :url => url, :name => "My blog :)" }
    end
  end

  context "responding to GET search" do
    before :each do
      @query = "blue"
      @documents = [Document.new]
      @documents.stub!(:suggest).and_return(@suggest = "ruby for dummies")
      Document.stub!(:search).and_return(@documents)
    end

    it "should search documents by the parameter q" do
      Document.should_receive(:search).with(@query, anything).and_return(@documents)
      get :search, :format => 'html', :q => @query
    end

    it "should paginate documents by the parameter page" do
      Document.should_receive(:search).with(anything, :page => '5').and_return(@documents)
      get :search, :format => 'html', :q => @query, :page => '5'
    end

    context "with html format" do
      it "renders the search template" do
        get :search, :format => 'html', :q => @query
        response.should render_template("search")
      end

      it "assigns the documents founds as @documents" do
        get :search, :format => 'html', :q => @query
        assigns[:documents].should eql(@documents)
      end
    end

    context "with json format" do
      it "should return found documents" do
        get :search, :format => 'json', :q => @query
        Crack::JSON.parse(response.body)['documents'].to_json.should eql(@documents.to_json)
      end

      it "should render a suggestion" do
        get :search, :format => 'json', :q => @query
        Crack::JSON.parse(response.body)['suggest'].should eql(@suggest)
      end
    end
  end
end
