module Kernel

  %w( get post put delete ).each do |verb|
    eval <<-end_eval
      def #{verb}(path, &block)
        Sinatra::Event.new(:#{verb}, path, &block)
      end
    end_eval
  end
  
  def after_attend(filter_name = nil, &block)
    Sinatra::Event.after_attend(filter_name, &block)
  end
  
  def helpers(&block)
    Sinatra::EventContext.class_eval &block
  end

end