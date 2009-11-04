module MilestonesHelper
  STATUS_BY_CRITERIAS = %w(category tracker priority author assigned_to)
  STATUS = %w(green yellow red)
  
  def render_project_status(summary)
    summary.downcase!
    status = "green" unless STATUS.include?(summary)
    status ||= summary
    render :partial=>"status", :locals => {:status => status}
  end
  
  
  def news_for_project(project)
    project.news.first  :conditions => ["created_on >= :start_date AND created_on <= :end_date", 
                                      {:start_date => 1.week.ago , :end_date => Time.now }],
                      :order => "created_on DESC"
  end
end
