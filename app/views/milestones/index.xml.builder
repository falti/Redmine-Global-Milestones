xml.instruct!

xml.projectreport :created => Time.now.to_date do
  @projects.each do |project|
    xml.project :name => project.name do
      news = news_for_project(project)
      
      if(news)
        xml.statusreport :status => current_project_status(news.summary) do
          xml.title news.title
          
          xml.text textilizable(news.description)
        end
      else
        xml.statusreport "N/A"
      end
      
      xml.milestones do
        project.versions.each do |version|
          xml.milestone :name => version.name, 
                        :due_date => version.effective_date, 
                        :completed => '%0.0f%' % version.completed_pourcent  do
                          
            issues = version.fixed_issues.find( :all,
                      :include => [:status, :tracker],
                      :conditions => ["issue_statuses.is_closed = ?", false] ,
                      :order => "#{Tracker.table_name}.position, #{Issue.table_name}.id")
            xml.issues :open => issues.count do
              
              issues.each  do |issue|
                #issue.to_xml(:only => [:subject, :created_on], :include=>:category, :builder => xml, :skip_instruct => true)
                xml.issue :subject => issue.subject, 
                          :created => issue.created_on.to_date, 
                          :status => issue.status.name,
                          :done =>  '%0.0f%' % issue.done_ratio
              end  
            end
            
          end
        end
      end
    end
  end
end