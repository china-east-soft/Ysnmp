class SnmpScheduler

  attr_accessor :scheduler
  attr_accessor :name

  class << self

    def all_schedulers
      @@schedulers
    end

    def klass_scheduler(klass)
      @@schedulers.select{|i| i.name == "#{klass}_scheduler" }.first
    end

  end

  def initialize(klass, frequency, &blk)
    self.name = "#{klass}_scheduler"
    self.scheduler = eval %{ @@#{klass}_scheduler }
    self.every_job(frequency, blk)
    @@schedulers << self.scheduler
  end

  def edit(frequency, &blk)
    self.stop
    self.scheduler.start
    every_job(frequency, blk)
  end

  def stop
    self.scheduler.shutdown(:kill)
  end

  def every_job(frequency, blk)
    self.scheduler.every "#{frequency}s" do
      blk.call
    end
  end

end