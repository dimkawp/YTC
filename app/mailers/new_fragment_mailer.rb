class NewFragmentMailer < ApplicationMailer
  default from: "ytcproject@gmail.com"

  def create_new_fragment_email(fragment)
    @user = User.find(fragment.user_id)
    @fragment = fragment
    mail to: @user.email, subject: 'Create New Fragment'
  end

end
