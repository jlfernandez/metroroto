class LinesController < ApplicationController
  
  def show 
    @line = Line.find(params[:id])
  end  
  
end
