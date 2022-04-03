class AppellationsController < ApplicationController

def index
  @appellations = Appellation.all
end

end
