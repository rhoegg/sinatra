require File.dirname(__FILE__) + '/../helper'

describe "When a dispatcher receives a request" do  
  
  before(:each) do
    Sinatra::EventManager.reset!
  end
      
  it "should attend to the event" do
    
    Sinatra::Event.new(:get, '/') do
      body 'this is the index as a get'
    end
    
    get_it "/"
        
    status.should.equal 200
    text.should.equal 'this is the index as a get'
    headers['Content-Type'].should.equal 'text/html'
    
    post_it "/"
        
    status.should.equal 404
    text.scan("Not Found :: Sinatra").size.should.equal 1
    headers['Content-Type'].should.equal 'text/html'
    
    get_it '/foo'
    
    status.should.equal 404
    text.scan("Not Found :: Sinatra").size.should.equal 1
    
  end
  
  it "should use custom error pages if present" do
    Sinatra::Event.new(:get, 404) do
      body 'custom 404'
    end
    
    get_it('/laksdjf').should.equal 'custom 404'
  end
  
  it "should reload app files unless in production" do
    Sinatra::Event.new(:get, '/') {}

    Sinatra::Options.expects(:environment).returns(:production)
    Sinatra::Loader.expects(:reload!).never
    get_it '/'
    
    Sinatra::Options.expects(:environment).returns(:development)
    Sinatra::Loader.expects(:reload!)
    get_it '/'
  end
  
  it "should not register not_found (otherwise we'll have a newone in the array for every error)" do
    Sinatra::EventManager.events.size.should.equal 0
    get_it '/blake'
    Sinatra::EventManager.events.size.should.equal 0
  end
    
end