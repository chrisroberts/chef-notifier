require 'chef'
require 'chef/handler'
require 'singleton'
require 'pony'

module ChefNotifier
  class Mailer < Chef::Handler

    include Singleton

    def setup(args={})
      @args = {:delivery => {:method => :sendmail, :arguments => '-i'}}.merge(args)
      @recipients = Array(@args[:recipients])
    end

    def report
      message = "#{run_status.formatted_exception}\n"
      message << Array(backtrace).join("\n")
      send_mail(message)
    end

    def warn(msg)
      send_mail(msg, "[Chef WARN #{Socket.gethostname}]")
    end

    def error(msg)
      send_mail(msg)
    end

    def info(msg)
      send_mail(msg, "[Chef INFO #{Socket.gethostname}]")
    end

    private

    def send_mail(message, subject=nil)
      deliver_to = @recipients
      unless(Array(deliver_to).empty?)
        Pony.mail(
          :to => deliver_to,
          :subject => subject || "[Chef ERROR #{Socket.gethostname}]",
          :from => "chef-client@#{Socket.gethostname}",
          :body => message,
          :via_options => {
            :arguments => @args[:delivery][:arguments]
          }
        )
      end
    end

  end
end
