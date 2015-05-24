class ActivitiesController < ApplicationController

  def index
    @activities = Activity.asc(:start_at)
    set_meta_tags title: "Activities"
  end

  def show
    @activity = Activity.find(params[:id])
    set_meta_tags title: @activity.name
  end


end
