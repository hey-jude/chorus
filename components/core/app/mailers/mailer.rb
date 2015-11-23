class Mailer < ActionMailer::Base

  def notify(user, event)
    @user = user
    @job = event.job
    @workspace = event.workspace
    @job_result = event.job_result
    @job_task_results = event.job_result.job_task_results

    #@email_with_name = '#{user.name} <#{user.email}>'


    attachments.inline[as_png('logo')] = logo(License.instance)

#    attachments[as_png(RunWorkFlowTaskResult.name)] = File.read(Core::Engine.root.join('public', 'images', 'workfiles', 'icon', 'afm.png'))
    attachments.inline[as_png(RunWorkFlowTaskResult.name)] = File.read(Core::Engine.root.join('public', 'images', 'jobs', 'task-afm.png'))
    attachments.inline[as_png(ImportSourceDataTaskResult.name)] = File.read(Core::Engine.root.join('public', 'images', 'jobs', 'task-import.png'))
    attachments.inline[as_png(ImportSourceDataTaskResult.name)] = File.read(Core::Engine.root.join('public', 'images', 'jobs', 'task-sql.png'))

    safe_deliver mail(:to => user.email, :subject => event.header)
  end

  def chorus_expiring(user, license)
    @user = user
    @expiration_date = license[:expires]
    @branding = license.branding
    attachments[as_png('logo')] = logo(license)

    #@email_with_name = '#{user.name} <#{user.email}>'

    safe_deliver mail(:to => user.email, :subject => 'Your Chorus license is expiring.')
  end

  private

  def logo(license)
    File.read(Core::Engine.root.join('public', 'images', 'branding', 'email', %(#{license.branding}-logo.png)))
  end

  def safe_deliver(mail)
    mail.deliver
  rescue => e
    Chorus.log_error "***** Mail failed to deliver "
    Chorus.log_error "#{e.message} : #{e.backtrace}"
  end

  module MailerHelper
    def build_backbone_url(path)
      urls = Rails.configuration.action_mailer.default_url_options
      "#{urls[:protocol]}://#{urls[:host]}:#{urls[:port]}/##{path}"
    end

    def as_png(name)
      %(#{name}.png)
    end
  end

  helper MailerHelper
  include MailerHelper
end
