module MilestonesHelper
  STATUS = %w(green yellow red)
  
  def render_project_status(summary)
    render :partial=>"status", :locals => {:status => current_project_status(summary) }
  end
  
  
  def current_project_status(summary)
    summary.downcase!
    status = "green" unless STATUS.include?(summary)
    status ||= summary
  end
  
  
  def news_for_project(project)
    project.news.first  :conditions => ["created_on >= :start_date AND created_on <= :end_date", 
                                      {:start_date => 1.week.ago , :end_date => Time.now }],
                      :order => "created_on DESC"
  end
end
