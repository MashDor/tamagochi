require 'sidekiq/api'

class JobSchedulerService
  class << self
    def schedule(job_class:, wait_time:, record:, job_column:)
      cancel(record:, job_column:)

      job = job_class.set(wait: wait_time).perform_later(record.id)

      record.update_column(job_column, job.provider_job_id)
    end

    def cancel(record:, job_column:)
      job_id = record.send(job_column)

      return unless job_id

      Sidekiq::ScheduledSet.new.each do |job|
        job.delete if job.jid == job_id
      end

      record.update_column(job_column, nil)
    end
  end
end
