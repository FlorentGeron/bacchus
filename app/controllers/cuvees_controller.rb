class CuveesController < ApplicationController

def index
@cuvees = Cuvee.all
end

def show
@cuvee = Cuvee.find(params[:id])
end

def new
end

def create
end

def edit
end

def update
end

def delete
end

end
