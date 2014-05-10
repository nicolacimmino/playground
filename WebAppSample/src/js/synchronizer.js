
self.onmessage = function(e)
{
	actions = e.data;
	xmlhttp=new XMLHttpRequest();
	xmlhttp.open("GET","../synchronizer.php?actions=" + actions, /*async=*/false);
	xmlhttp.send();
	if(xmlhttp.status == 200)
	{
		postMessage(actions);
	}
	else
	{
		postMessage("");
	}
}

