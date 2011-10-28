require 'chef'
require 'chef/handler'
require 'singleton'
require 'pony'

module ChefNotifier
  class Mailer < Chef::Handler

    include Singleton

    def setup(args={})
      @args = {:delivery => {:method => :sendmail, :arguments => '-i'}}.merge(args)
      self
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
      if(@args[:recipients])
        Pony.mail(
          :to => @args[:recipients],
          :subject => subject || "[Chef ERROR #{Socket.gethostname}]",
          :from => "chef-client@#{Socket.gethostname}",
          :body => message,
          :via_options => {
            :arguments => @args[:delivery][:arguments]
          }
        )
      else
        Chef::Log.warn 'Failed to send notification email. No recipients found provided.'
      end
    end

  end
end
