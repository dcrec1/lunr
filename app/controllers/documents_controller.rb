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

  protected

  def collection
    @documents = end_of_association_chain.paginate :page => params[:page]
  end

  def extract_html
    params[:document] = File.parse(params[:file]).to_hash if request.content_type.eql? Mime::MULTIPART_FORM
    params[:document] = Html.parse(request.raw_post).to_hash if request.content_type.eql? Mime::HTML
  end
end
