# Copyright 2011 Marek Jelen
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'amqp'

require 'thread'

require 'wildcloud/configuration'

require 'wildcloud/logeen/transport/raw'

module Wildcloud
  module Logeen
    class Engine

      def initialize
        @queue = Queue.new
      end

      def <<(message)
        @queue << message
      end

      def start
        @amqp = AMQP.connect(self.configuration['amqp'])
        @channel = AMQP::Channel.new(@amqp)
        @exchange = @channel.topic('wildcloud.logger')

        EventMachine.start_server('0.0.0.0', 4100, Wildcloud::Logeen::Transport::Raw, self)
        @thread = Thread.new do
          loop do
            msg = @queue.pop
            @exchange.publish(msg, :routing_key => 'wildcloud.logeen')
          end
        end
      end

      def configuration
        return @configuration if @configuration
        config = Wildcloud::Configuration.load('logeen')
        config.sources.each do |source|
          #self.logger.info('Configuration', "Loaded configuration from #{source}")
        end
        @configuration = config.configuration
      end

    end
  end
end