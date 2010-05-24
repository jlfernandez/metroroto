class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token

  rescue_from StandardError do |e|
    render :text => "Error: #{e.to_s}", :status => 500, :layout => false
    logger.error("ERROR EN LA API")
    logger.error(e.to_s)
    logger.error(e.backtrace.join("\n"))
  end


end
