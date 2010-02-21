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
      document = Nokogiri::HTML(html_or_io)
      document.search("script").each &:unlink
      params[:document] = { :head => element("head", :from => document), 
                            :body => element("body", :from => document) }
    end
  end
  
  def element(name, opts)
    opts[:from].search(name).first.content
  end
  
  def html_or_io
    request.raw_post.lstrip.start_with?("<") ? request.raw_post : Net::HTTP.get(URI.parse(request.raw_post))
  end
end