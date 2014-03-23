class WelcomeController < ActionController::Base
  
  def index

    f = "#{RRDPath}/test.rrd"

    unless File.exist? f
      cmd = "rrdtool create #{RRDPath}/test.rrd             \
              --start 920804400          \
              DS:speed:COUNTER:600:U:U   \
              RRA:AVERAGE:0.5:1:24       \
              RRA:AVERAGE:0.5:6:10"   


      system cmd

      (0..900*1000).step(900) do |t|
        # name = 920804400 + 300 + t
        # count = 12345 + rand(10)
        # cmd2= "rrdtool update #{RRDPath}/test.rrd #{name}:#{count} #{name + 300}:#{count+3} #{name+600}:#{count+5} "
        # 
        # system cmd2
        HardWorker.perform_async(920804400 + 300 + t, 12345 + rand(10))
      end

    end

    speed = params[:speed] || 3
    @@scheduler.stop(:terminate => true)
    @@scheduler = Rufus::Scheduler.new
    @@scheduler.every "#{speed}s" do
      puts "#{Time.now} Hello... Rufus"
    end

    cmd3 = "rrdtool graph #{RRDImg}/speed.png                                 \
         --start #{920804400} --end #{920804400 + 900*1000}               \
         DEF:myspeed=#{RRDPath}/test.rrd:speed:AVERAGE              \
         LINE2:myspeed#FF0000"

    system cmd3

  end
end
