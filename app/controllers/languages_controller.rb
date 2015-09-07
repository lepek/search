class LanguagesController < ApplicationController

  def index
    if params[:search].present?
      @results = Language.lookup(params[:search])
    end
  end

end
