class ProgramsController < ApplicationController
  
  layout 'admin'
  
  def index
    @programs = Program.all

    respond_to do |format|
      format.html
    end
  end

  def show
    redirect_to("/programs")
  end

  def new
    @program = Program.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @program = Program.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  def create
    @program = Program.new(params[:program])

    respond_to do |format|
      if @program.save
        flash[:notice] = 'Program was successfully created.'
        format.html { redirect_to("/programs") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @program = Program.find(params[:id])
    
    respond_to do |format|
      if @program.update_attributes(params[:program])
        flash[:notice] = 'Program was successfully updated.'
        format.html { redirect_to("/programs") }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @program = Program.find(params[:id])
    @program.destroy

    respond_to do |format|
      flash[:notice] = 'Program has been deleted.'
      format.html { redirect_to("/programs") }
    end
  end
end