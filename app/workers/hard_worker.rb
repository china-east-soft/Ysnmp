class HardWorker
  include Sidekiq::Worker

  def perform(name, count)
    cmd2 = "rrdtool update #{RRDPath}/test.rrd #{name}:#{count} #{name + 300}:#{count+3} #{name+600}:#{count+5} "
    pp cmd2
    system cmd2
    sleep(2)
  end
  
end