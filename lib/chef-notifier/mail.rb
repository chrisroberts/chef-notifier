require 'chef'
require 'chef/handler'
require 'singleton'
require 'mail'

module ChefNotifier
  class Mailer < Chef::Handler

    include Singleton

    def initialize(args={})
      args = {:delivery => {:method => :sendmail, :arguments => '-i'}}
      @recipents = Array(args[:receipents])
      Mail.defaults do
        delivery_method args[:delivery][:method], :arguments => args[:delivery][:arguments]
      end
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
      Mail.deliver do
        from "chef-client@#{Socket.gethostname}"
        to @recipents
        subject subject || "[Chef ERROR #{Socket.gethostname}]"
        body message
      end
    end

  end
end
