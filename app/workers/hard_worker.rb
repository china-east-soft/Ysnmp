class HardWorker
  include Sidekiq::Worker

  sidekiq_options :queue => :critical, :retry => false, :backtrace => true

  def perform(rrd_path, name, count)
    cmd2 = "rrdtool update #{rrd_path} #{name}:#{count}"
    system cmd2
  end
  
end