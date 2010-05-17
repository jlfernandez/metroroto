class Notifications < ActionMailer::Base

  layout 'notifications'
  
  
  def new_incident(email, incident,sent_at = Time.now)
    subject    I18n.translate("app.incident.email.new.subject", :line => incident.line.number)
    recipients email
    from       Settings.app.admin_email
    sent_on    sent_at
    body       :incident => incident
    content_type "text/html"
  end
  
end