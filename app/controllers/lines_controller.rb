class LinesController < ApplicationController
  
  def show 
    @line = Line.find(params[:id])
    respond_to do |wants|
      wants.html
      wants.atom { render :xml => collection_to_feed(@line.incidents).to_xml }
    end  
  end  
  
end
