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
var querystring = require("querystring");

function start(route, handle) {
  function onRequest(request, response) {
	var url_parts = url.parse(request.url, true);
    
	route(handle, url_parts.pathname, url_parts.query, response); 
  }

  http.createServer(onRequest).listen(8888);
  console.log("Server has started.");
}

exports.start = start;