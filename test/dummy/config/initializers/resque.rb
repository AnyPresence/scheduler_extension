Resque.redis = REDIS
Resque.inline = true
Resque.after_fork = Proc.new do
  Rails.logger.auto_flushing = true if Rails.logger.respond_to?(:auto_flushing)
  ActiveRecord::Base.establish_connection
end