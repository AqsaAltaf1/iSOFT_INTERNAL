# frozen_string_literal: true

class SearchController < ApplicationController
  def search
    if current_user.admin? || current_user.is_hr
      @query = params[:query]
      @results = []
      @results.concat(User.where('first_name ILIKE ? OR last_name ILIKE ?', "%#{@query}%", "%#{@query}%"))
      respond_to do |format|
        format.json { render json: @results }
        format.js { render js: "callback(#{JSON.generate(@results)});" }
      end
    else
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path 
    end
  end
end
