class Mailer < ActionMailer::Base

  def notify(user, event)
  
      email_with_name = '#{user.name} <#{user.email}>'
    @user = user
    @job = event.job
    @workspace = event.workspace
    @job_result = event.job_result
    @job_task_results = event.job_result.job_task_results
    
    attachments.inline[as_png('logo')] = logo(License.instance)
    
    email_image_tag_inline['afm.png', Rails.root.join('public', 'images', 'workfiles', 'icon', 'afm.png')]
    #attachments[as_png(RunWorkFlowTaskResult.name)] = File.read(Rails.root.join('public', 'images', 'workfiles', 'icon', 'afm.png'))
    

    #attachments[as_png(ImportSourceDataTaskResult.name)] = File.read(Rails.root.join('public', 'images', 'jobs', 'task-import.png'))
    email_image_tag_inline['task-import.png', Rails.root.join('public', 'images', 'jobs', 'task-import.png')]
    

    safe_deliver mail(:to => user.email, :subject => event.header)
  end

  def chorus_expiring(user, license)
    email_with_name = '#{user.name} <#{user.email}>'
    
    @user = user
    @expiration_date = license[:expires]
    @branding = license.branding
    attachments[as_png('logo')] = logo(license)

    safe_deliver mail(:to => user.email, :subject => 'Your Chorus license is expiring.')
  end

#  def notify_worklet_complete(user, event)
#    email_with_name = '#{user.name} <#{user.email}>'
#    @user = user
#    attachments[as_png('logo')] = logo(License.instance)
#
#    safe_deliver mail(:to => user.email, :subject => 'Your Touchpoint has completed.')
#  end


  private

  def logo(license)
    File.read(Rails.root.join('public', 'images', 'branding', 'mailer', %(#{license.branding}-logo.png)))
  end

  def safe_deliver(mail)
    mail.deliver
  rescue => e
    Chorus.log_error "***** Mail failed to deliver "
    Chorus.log_error "#{e.message} : #{e.backtrace}"
  end

    def email_image_tag_inline(image, imagepath, **options)
        attachments.inline[image] = {
            :data => File.read(#{imagepath}),
            :mime_type => "image/png",
            :encoding => "base64"
        }
        image_tag attachments.inline[image].url, **options
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


    module EmailHelper
        def email_image_tag(image, imagepath, **options)
            attachments[image] = {
                :data => File.read(Rails.root.join("app/assets/images/emails/#{image}")),
                :mime_type => "image/png",
                :encoding => "base64"
            }
            image_tag attachments[image].url, **options
        end

    end


  helper MailerHelper
  include MailerHelper
  
  helper EmailHelper
  include EmailHelper
  
end
