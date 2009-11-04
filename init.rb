require 'redmine'

Redmine::Plugin.register :redmine_global_milestones do
  name 'Redmine Global Milestones plugin'
  author 'Frank Falkenberg'
  description 'Provides Overview over all Projects/Milestones incl Export'
  version '0.0.1'
  menu :application_menu, :milestones, { :controller => 'milestones', :action => 'index' }, :caption => 'Milestones'
end