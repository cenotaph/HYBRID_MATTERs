class PostcategoriesController < ApplicationController
  
  def show
    @category = Postcategory.find(params[:id])
    if @category.project
      @project = @category.project
      if @project.node != @node
        redirect_to "http://#{@project.node.subdomains}/category/#{params[:id]}"
      end
    end

    @posts = @category.posts.published

  
      if @site
        render template: 'posts/index', layout: @site.layout
      else
        render template: 'posts/index'
      end
  

  end
  
end