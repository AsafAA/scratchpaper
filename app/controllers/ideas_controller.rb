class IdeasController < ApplicationController
  before_action :set_idea, only: [:show, :edit, :update, :destroy, :like, :follow]
  before_filter :authenticate_user!

  # GET /ideas
  # GET /ideas.json
  def index
    @ideas = Idea.all
  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
  end

  # GET /ideas/new
  def new
    @idea = Idea.new
  end

  # GET /ideas/1/edit
  def edit
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea = Idea.new(idea_params)

    if user_signed_in?
      @idea.user = current_user
    end

    respond_to do |format|
      if @idea.save
        format.html { redirect_to ideas_path}
        format.json { render action: 'show', status: :created, location: @idea }
      else
        format.html { render action: 'new' }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ideas/1
  # PATCH/PUT /ideas/1.json
  def update
    respond_to do |format|
      if @idea.update(idea_params)
        format.html { redirect_to @idea } #, notice: 'Idea was successfully updated.'
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea.destroy
    respond_to do |format|
      format.html { redirect_to ideas_url }
      format.json { head :no_content }
    end
  end

  def like
    @idea.vote :voter => current_user
    redirect_to ideas_path
  end

  def follow
    current_user.follow(@idea)
    redirect_to ideas_path
  end

  def create_update
      @idea = Idea.find(params["id"])
      @contributor = @idea.contributors.where(:user => current_user).first
      @idea.updates.create(:description => params["update"]["description"], :idea => @idea, :contributor => @contributor, :user => current_user)
      redirect_to :back
  end

  def contribute
    @idea = Idea.find(params[:id])
    if not @idea.contributors.exists?(:user => current_user)
        @contributor = @idea.contributors.create(:user => current_user, :idea => @idea)
    end
    respond_to do |format|
        format.html{ redirect_to :back }
        format.js
    end
  end

  def uncontribute
    @idea = Idea.find(params[:id])
    @contributor = @idea.contributors.where(:user => current_user).first
    if @idea.contributors.exists?(:user => current_user)
        @contributor.destroy
    end
    respond_to do |format|
        format.html{ redirect_to :back }
        format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_idea
      @idea = Idea.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def idea_params
      params.require(:idea).permit(:blurb, :problem, :solution, :description, :photo, attachments_attributes: [:attach])
    end
end
