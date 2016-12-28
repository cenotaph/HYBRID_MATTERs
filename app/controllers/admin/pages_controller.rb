class Admin::PagesController < Admin::BaseController
 
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    # sortable_column_order do |column, direction|
    #   @pages = Page.by_node(@node).sort_by(column, direction)
    # end
    @pages = @node.pages.desc('updated_at')
    set_meta_tags title: 'Pages'
    respond_with(@pages)
  end
  

  

  def show
    redirect_to @page
  end

  def new
    @page = Page.new
    set_meta_tags title: 'New page'
    respond_with(@page)
  end

  def edit
    set_meta_tags title: 'Edit page - ' + @page.try(:title)
  end

  def create
    @page = Page.new(page_params)
    @page.node = @node
    @page.save
    redirect_to admin_pages_path
  end

  def update
    @page.update(page_params)
    redirect_to admin_pages_path
  end

  def destroy
    @page.destroy
    redirect_to admin_pages_path
  end

  private
    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :body, :image, :subsite_id, :background, :excerpt, :activity_id, :published, :image, :remove_background, :remove_image, photos_attributes: [:image, :id,  :_destroy])
    end
end
