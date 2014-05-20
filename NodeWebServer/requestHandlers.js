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
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(':memory:');

function initialize()
{
	db.serialize(function() {
		db.run("CREATE TABLE vals (key TEXT, value TEXT)");

		var stmt = db.prepare("INSERT INTO vals (key, value) VALUES (?,?)");
		stmt.run("bla", "bla@test.com");
		stmt.run("bla2", "blatwo@test.com");
		
		stmt.finalize();
	});
}

function get(pathname, parameters, response) {
	
	console.log(parameters);
		
	db.serialize(function() {
		var body = "";		
		db.get("SELECT key, value FROM vals WHERE key=?", parameters['key'], function(err, row) {
			if(row!=undefined) {
				body = row.value;
			}
			response.writeHead(200, {"Content-Type": "text/plain"});
			response.write(body);
			response.end();
		});
	});

}

function set(pathname, parameters, response) {
	
	console.log(parameters);
		
	db.serialize(function() {
		var stmt = db.prepare("INSERT INTO vals (key, value) VALUES (?,?)");
		stmt.run(parameters['key'], parameters['value']);
		stmt.finalize();
		
		response.writeHead(200, {"Content-Type": "text/plain"});		
		response.write("OK");
		response.end();
	});

}

exports.initialize = initialize;
exports.get = get;
exports.set = set;
