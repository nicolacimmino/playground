
Node.js Web Server
=============

A simple reference design of a Web Server in Node.js implementing a simple API exposing a key/value store accessible trough simple URLs:

http://127.0.0.1:8888/set?key=test&value=12

http://127.0.0.1:8888/get?key=test

This is on purpose NON ReSTful to keep code simple, another example will show a REsTful service, for that Express will be used as it simplifies greatly things.

