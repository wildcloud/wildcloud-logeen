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

require 'syslog_protocol'

module Wildcloud
  module Logeen
    module Transport

      module Syslog

        include EventMachine::Protocols::LineText2

        def initialize(engine)
          @engine = engine
        end

        def post_init

        end

        def receive_line(data)
          message = SyslogProtocol.parse(data)
          @engine << {
              "level" => message.severity_name,
              "application" => message.hostname,
              "component" => message.facility_name,
              "message" => message.content,
              "timestamp" => message.time.to_i
          }
        end

        def unbind

        end

      end

    end
  end
end