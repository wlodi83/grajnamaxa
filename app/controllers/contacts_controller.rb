class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.request = request
    if @contact.deliver
      flash.now[:notice] = 'Twoja wiadomość została wysłana pomyślnie. Dziękujemy!'
    else
      flash.now[:error] = 'Ta wiadomość nie mogła zostać wysłana. Spróbuj ponownie.'
      render :new
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :email, :message, :nickname)
  end
end