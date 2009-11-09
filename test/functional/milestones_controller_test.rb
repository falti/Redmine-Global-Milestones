require File.dirname(__FILE__) + '/../test_helper'

begin
  require 'mocha'
rescue
  # Won't run some tests
end

class MilestonesControllerTest < ActionController::TestCase
  

  def setup
    @controller = MilestonesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
  end
  
  if Object.const_defined?(:Mocha)
  
    def test_index_html
      project = Project.new
      version = Version.new
      news_collection = []
      news = News.new
      Project.expects(:find).returns([project]).at_least_once
      project.expects(:versions).returns([version]).at_least_once
      project.expects(:news).returns(news_collection).at_least_once
      news_collection.expects(:first).returns(news).at_least_once
      news.expects(:summary).returns("This is a summary")
      news.expects(:created_on).returns(Time.now)
      news.expects(:description).returns("This is a description")
      
      
      
      @request.session[:user_id] = 2
      get :index
      assert_response :success
      assert_template 'index'
      
    
    end
  
  else
    puts 'Mocha is missing. Skipping tests.'
  end
  
  
end
