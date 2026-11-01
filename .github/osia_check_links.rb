#!/usr/bin/env ruby
# awesome_bot checks links one at a time per thread and only applies
# --set-timeout to the TCP open. A response that trickles can hold a
# thread until the job limit. Force both limits in this process.
require 'net/http'

module Net
  class HTTP
    def open_timeout
      20
    end

    def read_timeout
      20
    end
  end
end

require 'awesome_bot'

AwesomeBot.cli
