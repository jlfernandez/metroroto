class Notifications < ActionMailer::Base

  layout 'notifications'
  helper :application
  def new_incident(subscription, incident,sent_at = Time.now)
    subject    I18n.translate("app.incident.email.new.subject", :line => incident.line.number, :station => incident.station.name)
    recipients subscription.email
    from       Settings.app.admin_email
    sent_on    sent_at
    body       :incident => incident, :subscription => subscription
    content_type "text/html"
  end
  
end