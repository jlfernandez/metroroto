class SubscriptionsController < ApplicationController

  def create
    if params[:line_ids]['all'] == "true"
      Line.all.each do |line|
        Subscription.find_or_create_by_email_and_line_id(:email => params[:subscription][:email], :line_id => line.id)
      end
    else
      params[:line_ids].each_key do |line_id|
        Subscription.find_or_create_by_email_and_line_id(:email => params[:subscription][:email], :line_id => line_id) 
      end
    end
    respond_to do |format|
      format.html do
        flash[:notice] = "Hemos creado correctamente tu suscripción :)"
      end
      format.js do
        render :update do |page| 
          page << '$("form#new_subscription button").hide();'
          page.replace_html 'data', "<p class='subscription_notice'>¡Tu suscripción ha sido guardada correctamente :) !</p>" 
        end
      end

    end
  end
  
  def edit
    if @subscription = Subscription.find(params[:id])
      if @subscription.verification_token == params[:verification_token]
         if params[:all] == "true"
          Subscription.find_all_by_email(@subscription.email).each {|a| a.destroy}
         else
           @subscription.destroy
         end
         flash[:notice] = "Hemos eliminado correctamente tu suscripción :)"
         redirect_to root_path
      else
        render :layout => false, :status => '404' 
      end
    else
      render :layout => false, :status => '404' 
    end
  end

end
