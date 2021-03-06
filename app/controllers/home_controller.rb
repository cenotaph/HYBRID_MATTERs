class HomeController < ApplicationController


  def about
    @about_text = @node.pages.find('about-the-bioart-society') rescue nil
    @board_staff = @node.pages.find('board-and-staff') rescue nil
    @members = @node.pages.find('members') rescue Page.new
    @collaborators = @node.pages.find('collaborators') rescue Page.new
    set_meta_tags title: "About"
  end

  def index
    @call = Call.first
    redirect_to @call
  end

  def home
    if @node.name == 'hybrid_matters'
      if @activity # if activity already exists from exhibitions URL
        @posts = @activity.posts.published.order(:published_at.desc)
        set_meta_tags title: 'Posts for activity ' + @activity.name
        render layout: @site.layout
      elsif params[:activity_id]
        @activity = Activity.find(params[:activity_id])
        if @activity.subsite && @site.nil?
          redirect_to subdomain: @activity.subsite.subdomain
        elsif @activity.activity_type == 'exhibition'
          if @activity.url_name.blank?
            redirect_to "http://exhibitions.hybridmatters.net/posts"
          else
            redirect_to "http://exhibitions.hybridmatters.net/#{@activity.url_name}/posts"
          end
        else
          @posts = @activity.posts.published.order(:published_at.desc)
          set_meta_tags title: 'Posts for  ' + @activity.name
          render layout: @site.layout, template: 'posts/index'
        end
      else

        if @site

            @posts = Post.by_subsite(@site.id).published.order(published_at: :desc)
            set_meta_tags title: @site.name + ": News"
            render layout: @site.layout, template: 'posts/index'

        else

          @posts = Post.by_node(@node).published.order(published_at: :desc)

          set_meta_tags title: "News"
          render template: 'posts/index'
        end
      end

    # SOLU site here
    else
      @frontitems = @node.frontitems.published
      whatsnew = [Post.published.order(published_at: :desc), Activity.published.where(:eventsessions.ne => nil, :hide_from_whats_new.ne => true)].flatten.sort_by(&:sort_date).reverse
      # @posts = Post.published.order(published_at: :desc).page(params[:page]).per(12)
      @posts = Kaminari.paginate_array(whatsnew).page(params[:page]).per(12)
      # @about = @node.pages.find('about-the-bioart-society') rescue nil
      # @ars = @node.pages.find('ars-bioarctica-front') rescue nil
      # @calls = Project.find('ars-bioarctica').calls.active
      # @activities = Activity.by_node(@node.id).desc(:start_at).limit(12)
      # @projects = Project.featured.published.sort_by{|x| x.year_range.split('-').last.to_i}.reverse
      if request.xhr?
        render layout: false, partial: 'home/wnpiece'
      end
    end
  end
end
