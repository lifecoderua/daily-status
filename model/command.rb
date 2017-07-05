class Command
  attr_reader :action

  #TODO: better naming, maybe `@` for personal information setup
  # ACTIONS = %w(name email report send)

  def initialize params
    @params = params.symbolize_keys
    @action, @data = /^(\!(@?\w+) )?(.*)/m.match(@params[:text])[2..3]
    @user = User.get(@params[:user_id], params[:user_name])
  end

  def result
    @action ||= :status
    case @action.to_sym
      when :@name
        @user.update( name: @data)
        "User updated as #{@user.inspect}"
      when :@email 
        @user.update( email: @data)
        "User updated as #{@user}"
      else # status
        Status.apply(@user.user_id, @data)
        # .update({
        #   status: @data
        # })
    end
  end

private  

end