class DocumentsController < InheritedResources::Base
  respond_to :html, :json, :xml
  
  before_filter :extract_html, :only => :create

  def search
    @documents = Document.search(params[:q], :page => params[:page])
    respond_to do |format|
      format.html
      format.json { render :json => Search.new(@documents) }
    end
  end
  
  def collection
    @documents = end_of_association_chain.paginate :page => params[:page]
  end
  
  protected
  
  def extract_html
    if request.content_type.eql? Mime::HTML
      document = Nokogiri::HTML(request.raw_post)
      params[:document] = { :head => document.search("head").first.inner_text, 
                            :body => document.search("body").first.inner_text }
    end
  end
end