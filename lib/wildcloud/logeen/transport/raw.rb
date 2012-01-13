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

require 'snappy'

module Wildcloud
  module Logeen
    module Transport

      class Raw < EventMachine::Connection

        def initialize(engine = nil)
          super
          @engine = engine
        end

        def post_init
          @buffer = ''
          @offset = 0
          @length = nil
          @separator = "\n"
        end

        def receive_message(message)
          @engine << message if @engine
        end

        def receive_data(data = '')

          @buffer << data

          if @length == 0
            if mark = @buffer.index("\n\0\n")
              @length = nil
              @buffer = "#{mark+2}#{@separator}" + @buffer
            end
          end

          unless @length
            mark = @buffer.index(@separator)
            if mark
              @length = @buffer[0, mark].to_s.to_i
              @buffer = @buffer[(mark+1)..-1]
            end
          end

          if @length && @length > 0 && @buffer.size >= @length

            data = @buffer[0..@length]

            message = decode_message(data)

            receive_message(message)

            @buffer = @buffer[(@length+1)..-1]
            @buffer ||= ''
            @length = nil

            receive_data

          end

        end

        def decode_message(buffer)
          type = buffer[0].to_s.unpack('B*').first.to_i(2)
          data = buffer[1..-1]

          case type
            # 0
            when 48
              data
            # b
            when 98
              decode_message(data.unpack('m*').first)
            # s
            when 115
              decode_message(Snappy.inflate(data))
            else
              nil
          end

        rescue Exception
          puts "Exception"
        end

        def unbind

        end

      end

    end
  end
end