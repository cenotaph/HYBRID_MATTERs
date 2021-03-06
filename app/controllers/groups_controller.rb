class GroupsController < ApplicationController
  before_action :set_subdomain

  def index
    if @site.symposium.nil?
      redirect_to 'https://hybridmatters.net'
    else
      @groups = @site.symposium.groups.order(name: :asc)
      set_meta_tags title: @site.symposium.name + ": Groups"
      render layout: @site.layout
    end
  end
 
  def show
    @group = @site.symposium.groups.find(params[:id])
    set_meta_tags title: @site.symposium.name + ": " + @group.name
    render layout: @site.layout
  end
     
  private
 
  def set_subdomain
    if @site.nil?
      redirect_to subdomain: 'fieldnotes' # hardcoded here til we have another subsite with groups
    end 
  end
end