
self.onmessage = function(e)
{
	actions = e.data;
	xmlhttp=new XMLHttpRequest();
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4) {
			postMessage(xmlhttp.responseText);
		}
	}
	xmlhttp.timeout = 5000;
	xmlhttp.open("GET","../serverinfo.php", /*async=*/false);
	xmlhttp.send();
	if(xmlhttp.status != 200)
	{
		postMessage("");
	}
}

