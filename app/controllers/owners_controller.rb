class OwnersController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout 'application'
  protect_from_forgery with: :exception
  def login
  end

  def clear
    session.clear
    redirect_to "/"
  end

  def edit
    @owner=Owner.find(params[:id])
  end

  def update
    Owner.find(params[:id]).update(owner_params)
    redirect_to "/owners/#{session[:id]}/show"
    
  end

  def log
    owner = Owner.find_by_email(owner_params[:email])
    if owner
      session[:id] = owner.id
      redirect_to "/owners/#{session[:id]}/show"
    else
      flash[:errors] = ["Invalid login"]
      redirect_to :back
    end
  end

  def logout
    session[:id] = nil
    redirect_to "/"
  end

  def index
    @animals=Animal.all
  end

  def create
		#inserts user into DB if validations pass, and redirects to users logged in page
		owner = Owner.new(owner_params)
		  if owner.valid?
        owner.save
        new_owner = Owner.find_by_email(owner_params[:email])
        session['id'] = new_owner.id
        redirect_to "/owners/#{session[:id]}/show"
      else
        flash[:errors]=owner.errors.full_messages
        redirect_to :back
      end
	end
	# def addpetpage
  #   @animal = Animal.all
	# end

	def addpet
		pet = Pet.new(animal_params)
	  if pet.valid?
       pet.save
       redirect_to "/owners/#{session[:id]}/show"
    else
        flash[:errors]=pet.errors.full_messages
        redirect_to :back
    end
	end
  def show
    @owner= Owner.find(session[:id])
    @pet = Pet.where(owner_id: session[:id])
    @accepted=Acceptance.all
  end
	private
	 	def animal_params
      params.require(:pet).permit(:name, :age, :kind)
    end
    def owner_params
      params.require(:owner).permit(:first_name, :last_name, :email, :zip, :password, :password_confirmation, :phone, :state, :address, :city)
    end
end
