class LanguagesController < ApplicationController

  def index
    if params[:search].present?
      @results = Language.look(params[:search])
    end
  end

end
