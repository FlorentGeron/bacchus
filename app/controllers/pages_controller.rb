class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if user_signed_in?
      homepath = current_user.caves.count.positive? ? cuvees_path : new_cave_path
      redirect_to homepath
    end
  end

  def settings
  end

  def welcome
  end
end
