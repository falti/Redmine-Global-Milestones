class MilestonesController < ApplicationController
  unloadable

  def index
    time_range = (1.week.ago)..Time.now
    @projects = Project.find  :all,
                              :conditions => Project.visible_by(User.current)
    respond_to do |format|
      format.html
      format.xml { render :layout => false}
    end
  end
  
end
