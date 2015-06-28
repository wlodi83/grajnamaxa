class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message
  attribute :nickname, captcha: true

  def headers
    {
      subject: "Wiadomośc z serwisu grajnamaxa.pl",
      to: "kontakt.grajnamaxa@gmail.com",
      from: %("#{name}" <#{email}>)
    }
  end
end