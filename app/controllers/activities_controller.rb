class ActivitiesController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @activities = @project.activities.published.desc(:start_at)
    else
      @activities = Activity.by_node(@node.id).published.asc(:start_at)
    end
    set_meta_tags title: "Activities"
  end

  def show
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @activity = @project.activities.find(params[:id])
    else
      @activity = Activity.find(params[:id])
      unless @activity.projects.empty? 
        redirect_to project_activity_url(@activity.projects.first, @activity) and return
      end
    end
    set_meta_tags title: @activity.name,
    og: { title: @activity.name, type: 'article',
      url: url_for(@activity),
      description: ActionView::Base.full_sanitizer.sanitize(truncate(strip_tags(@activity.description), length: 400)),
      image: @activity.photos.empty? ? false : @activity.photos.first.image.url(:box)
    },
    canonical: url_for(@activity)
    if !@activity.published?
      if user_signed_in? && current_user.has_role?(:admin)
        flash[:notice] = 'DRAFT, not published yet'
        render template: 'activities/show'
      else
        flash[:error] = 'That activity is not yet published.'
        redirect_to activities_path
      end
    else
     
      render template: 'activities/show'
    end
  end

end
