@@schedulers = []

schedulers_klass = %w{ check }

schedulers_klass.each do |klass|
  eval %{ @@#{klass}_scheduler = Rufus::Scheduler.new }
end

if system 'ps aux | grep sidekiq'
  Rule.all.each do |r|
    r.send :create_scheduler  
  end
end