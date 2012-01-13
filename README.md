# Wildcloud - Logeen

Collects logging messages and forwards them further.

## Inputs

### Raw

Protocol consists of message. Each message begins with size od payload separated from payload by new line character.

        (size)\n(payload)

Payload consists of two parts not separated. Type is one byte and contains information of the message encoding.
Message is the actual message.

        (encodings)(message)

When size is 0, the message is considered a stream. The data are be buffered till ending sequence is received.

        0\n(stream)\n\0\n

Available encodings

char    dec     description
 0       48     not encoded message
 b       98     base 64 encoded message
 s      115     Google's snappy compressed message

Encodings are nested. Message is being recursively decoded until encoding 0 or unknown encoding is reached.

#### Example

From network come data

        10\0bMHRlc3Q=\n

the message has the length 10 and is base64 encoded. The result from the first round is

        0test

not encoded string is found and is therefore returned.

# License

Project is licensed under the terms of the Apache 2 License.
