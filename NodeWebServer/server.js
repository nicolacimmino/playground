/* server.js is part of NodeWebSample.
 *   Copyright (C) 2014 Nicola Cimmino
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see http://www.gnu.org/licenses/.
 *
*/

var http = require("http");
var url = require("url");

function start(route, handle) {
  function onRequest(request, response) {
	var postData = ""; 
    var pathname = url.parse(request.url).pathname;
    console.log("Request for " + pathname + " received.");
	
	request.setEncoding("utf8");
	request.addListener("data", function(postDataChunk) { postData += postDataChunk; console.log("Received POST data chunk '"+ postDataChunk + "'."); });
	request.addListener("end", function() { route(handle, pathname, response, postData); })
  }

  http.createServer(onRequest).listen(8888);
  console.log("Server has started.");
}

exports.start = start;