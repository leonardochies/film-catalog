class ImportMailer < ApplicationMailer
  def notify_success(job)
    @user = job.user
    mail(to: @user.email, subject: "Sua importação de filmes foi concluída!")
  end

  def notify_failure(job)
    @user = job.user
    @error = job.error_message
    mail(to: @user.email, subject: "Houve um erro na sua importação de filmes")
  end
end
