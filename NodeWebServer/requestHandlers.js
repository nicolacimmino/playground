/* requestHandler.js is part of NodeWebSample.
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

var jade = require('jade');
var fs = require('fs');

function login(response, postData) {
	fs.readFile('login.jade', 'utf8', function (err, data) {
		if (err) {
			response.writeHead(500, {"Content-Type": "text/html"});
			response.write("Internal Server Error");
			response.end();
			return;
		}
		
			var body = jade.compile(data)({
			  user: {
				name: 'nicola',
				password: ''
			  }
			});
	
		response.writeHead(200, {"Content-Type": "text/html"});
		response.write(body);
		response.end();
	});
}

function upload(response, postData) {
	console.log("Request handler 'upload' was called.");
	response.writeHead(200, {"Content-Type": "text/plain"});
	response.write("You've sent: " + postData);
	response.end();
}

exports.login = login;
exports.upload = upload;
