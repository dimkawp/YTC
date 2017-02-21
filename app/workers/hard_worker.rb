class HardWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something
    HardWorker.perform_async('bob', 5)
  end
end
