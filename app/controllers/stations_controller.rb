class StationsController < ApplicationController
  before_filter :load_line

  def index
   @stations = @line.stations
    respond_to do |format|
     format.json do
       render :json => @stations.collect{|a| [a.name,a.id]}
     end
    end
  end

  private

  def load_line
    @line = Line.find(params[:line_id])
  end
end

