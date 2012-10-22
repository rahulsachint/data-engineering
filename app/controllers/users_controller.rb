
class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update, :show]
  
  def show
    @user = User.find(params[:id])
    
    @title = @user.name
  end
  
  def new
      @user = User.new
      @title = "Sign Up"
  end
  
  def create 
      @user = User.new(params[:user])
      if @user.save
          sign_in @user
          flash[:success] = "Welcome to the Sample App!"
          redirect_to @user
      else
          @title = "Sign Up"
          render 'new'
      end
  end
  
  def edit
      @user = User.find(params[:id])
      @title = "Edit user"
  end
  
  def update
    # @user = User.find(params[:id])
    # if @user.update_attributes(params[:user])
    #   flash[:success] = "Profile updated."
    #   redirect_to @user
    # else
    #   @title = "Edit user"
    #   render 'edit'
    # end

    @title = "Upload file"
    @user = User.find(params[:id])
    
    @user.datafile = params[:user][:datafile]
    puts "Read datafile and stored it at #{@user.datafile.current_path}"
    
    
    respond_to do |format|
      if @user.update_attribute('datafile', params[:user][:datafile])
        flash[:success] = "File uploaded!"
        
        # Processing file
        f = File.open(@user.datafile.current_path, "r")
        flag = 0
        @revenue = 0
        
        f.each_line { |line|
        # Processing file line by line and saving each item in the database
          if flag != 0
            
            # Breaks if blank lines are present at the end
            break if line == "\n"
            puts line
            words = line.split("\t")
            
            break if words.count != 6

            # Saves each line in an item and stores it in the database
            # Assuming the input file is in order
            @item = Item.new
            @item.purchaser_name = words[0]
            @item.item_description = words[1]
            @item.item_price = words[2].to_f
            @item.purchase_count = words[3].to_f
            @item.merchant_address = words[4]
            if words[5] != nil
              @item.merchant_name = words[5].delete("\n")
            end
            
            # Calculates the gross revenue
            @revenue = @revenue + (@item.item_price * @item.purchase_count)
            
            if !@item.save
                flash[:notice] = "Unable to insert info into database!"
                render 'pages/home'
            end
          end
          
          flag = 1
          
        }
        
        if @user.update_attribute('gross_revenue', @revenue)
          puts "Gross revenue updated for user #{@revenue}"
        end
        
        f.close
         
        format.html { redirect_to root_path }
      else
        flash[:notice] = "Unable to upload file!"
        format.html { render 'pages/home' }
      end
    end    
    
  end
  
  
  def index
    @title = "All users"
    # @users = User.paginate(:page => params[:page])
    @users = User.order(:name).page params[:page]
    puts @users
    # @users = User.all
  end
  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
