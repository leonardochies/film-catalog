class ImportJobsController < ApplicationController
  before_action :authenticate_user!
  def new
    @import_job = ImportJob.new
  end

  def create
    @import_job = current_user.import_jobs.new(import_job_params.merge(status: "pending"))
    if @import_job.save
      ImportCsvWorker.perform_async(@import_job.id)
      redirect_to import_jobs_path, notice: "Importação iniciada!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @import_jobs = current_user.import_jobs.order(created_at: :desc)
  end

  private
  def import_job_params
    params.require(:import_job).permit(:csv_file)
  end
end
