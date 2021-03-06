class UsersController < ApplicationController

  load_and_authorize_resource

	before_action :authenticate_user!
	
	before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if current_user
      if current_user.has_role?('Admin') || current_user.has_role?('Manager')
        User.skip_callback(:create, :after, :set_default_user_role)
        
      end
    end


    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, flash: {success: "User was successfully created."}  }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    #raise
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, flash: {info: "User was successfully updated."} }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, flash: {info: "User was successfully deleted."} }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :role_id, :password, :password_confirmation)
    end
end
