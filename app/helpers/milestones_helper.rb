module MilestonesHelper
  STATUS_BY_CRITERIAS = %w(category tracker priority author assigned_to)
  STATUS = %w(green yellow red)
  
  def render_project_status(summary)
    summary.downcase!
    status = "green" unless STATUS.include?(summary)
    status ||= summary
    render :partial=>"status", :locals => {:status => status}
  end
  
  def render_issue_status_by(version, criteria)
    criteria ||= 'category'
    raise 'Unknown criteria' unless STATUS_BY_CRITERIAS.include?(criteria)
    
    h = Hash.new {|k,v| k[v] = [0, 0]}
    begin
      # Total issue count
      Issue.count(:group => criteria,
                  :conditions => ["#{Issue.table_name}.fixed_version_id = ?", version.id]).each {|c,s| h[c][0] = s}
      # Open issues count
      Issue.count(:group => criteria,
                  :include => :status,
                  :conditions => ["#{Issue.table_name}.fixed_version_id = ? AND #{IssueStatus.table_name}.is_closed = ?", version.id, false]).each {|c,s| h[c][1] = s}
    rescue ActiveRecord::RecordNotFound
    # When grouping by an association, Rails throws this exception if there's no result (bug)
    end
    counts = h.keys.compact.sort.collect {|k| {:group => k, :total => h[k][0], :open => h[k][1], :closed => (h[k][0] - h[k][1])}}
    max = counts.collect {|c| c[:total]}.max
    
    render :partial => 'issue_counts', :locals => {:version => version, :criteria => criteria, :counts => counts, :max => max}
  end
  
  def status_by_options_for_select(value)
    options_for_select(STATUS_BY_CRITERIAS.collect {|criteria| [l("field_#{criteria}".to_sym), criteria]}, value)
  end
  
  def news_for_project(project)
    project.news.first  :conditions => ["created_on >= :start_date AND created_on <= :end_date", 
                                      {:start_date => 1.week.ago , :end_date => Time.now }],
                      :order => "created_on DESC"
  end
end
