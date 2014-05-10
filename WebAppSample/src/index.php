<?php
	session_start();
	if(!isSet($_SESSION['actions_list']))
	{
		$_SESSION['actions_list'] = "";
	}
?>
<head>
<script type="text/javascript" src="js/jquery-2.1.0.min.js"></script>
<script type="text/javascript" src="js/webapp.js"></script> 	
<link rel="stylesheet" type="text/css" href="css/webapp.css" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
</head>
<body onload="start_application();">
<!--
	+----------------+--------------------------+
	+ Status         | Timer                    +
	+------------+---+--------------------------+
	+            |                              +
	+ Start/Stop |  Screens Area                +
	+            |                              +
	+------------+------------------------------+
-->
<div id='status_bar'>Ready.</div>
<div id='timer_bar'>&nbsp;</div>
<div id='start_stop_area'>
	<div id='start_button' class='image_button' onclick='start_action();'>&nbsp;</div>
	<div id='stop_button' class='image_button' onclick='stop_action();'>&nbsp;</div>
</div>
<div id='screens_area'>
<div id ='screen_1' class='screen'>
Main application screen, shown at startup and in stopped state.
<div id='show_actions_button' class='button' onclick='show_screen("screen_3");'>History</div>
<div id='show_actions_button' class='button' onclick='show_server_info();'>Server Info</div>
</div>
<div id ='screen_2' class='screen'>
Action screen shown when application timer is running.
<div id='action_button_1' class='button' onclick='do_action(1);'>Action 1</div>
<div id='action_button_2' class='button' onclick='do_action(2);'>Action 2</div>
<div id='action_button_3' class='button' onclick='do_action(3);'>Action 3</div>
</div>
<div id ='screen_3' class='screen'>
<div id='actions_list'><?php echo str_replace("|","<br>",$_SESSION['actions_list']); ?></div>
<div class='button' onclick='show_screen("screen_1");'>Back</div>
</div>
<div id ='screen_4' class='screen'>
<div id='server_info'>&nbsp;</div>
<div class='button' onclick='show_screen("screen_1");'>Back</div>
</div>
</div>


<script>
	worker = new Worker("js/synchronizer.js");		
	worker.onmessage = function(e)
	{
		if(e.data != "")
		{
			localStorage['actions_queue'] = localStorage['actions_queue'].replace(e.data, "");
			$("#topbar").html("Sync done.");
		}
		else
		{
			$("#topbar").html("Sync failed.");
		}
		setTimeout("sync_server()", 1000);
	};
  
	function sync_server()
	{
		if(localStorage['actions_queue'] != null && localStorage['actions_queue'] != "")
		{
			$("#status_bar").html("Sync ongoing...");
			worker.postMessage(localStorage['actions_queue']);
		}
		else
		{
			$("#status_bar").html("Ready.");
			setTimeout("sync_server()", 1000);
		}
		
		if(localStorage.getItem("started_time") > 0)
		{
			$("#timer_bar").html(secondsToHms(new Date()/1000 - localStorage.getItem("started_time")));
		}
		else
		{
			$("#timer_bar").html("&nbsp;");
		}
	}
	
	function start_action()
	{
		localStorage.setItem("started_time",  new Date()/1000);
		show_screen("screen_2");
		$("#stop_button").css( "display", "block" );
		$("#start_button").css( "display", "none" );
	}
	
	function stop_action()
	{
		localStorage.setItem("started_time",  0);
		show_screen("screen_1");
		$("#stop_button").css( "display", "none" );
		$("#start_button").css( "display", "block" );
	}
	
	function do_action(action)
	{
		var datetime = new Date();
		action_label = "Action" + action + " " + secondsToHms(datetime/1000);
		$("#actions_list").html($("#actions_list").html() + action_label + "<br>"); 
		localStorage.setItem("actions_queue", localStorage.getItem("actions_queue") + action_label + "|");
	}
	
	function show_server_info()
	{
		show_screen("screen_4");
		$("#server_info").html("Fetching info...");
		worker_serverinfo.postMessage("");
	}
	
	worker_serverinfo = new Worker("js/serverinfo.js");		
	worker_serverinfo.onmessage = function(e)
	{
		if(e.data != "")
		{
			$("#server_info").html(e.data);
		}
		else
		{
			$("#server_info").html("Cannot contact server.");
		}
	};
	
	function show_screen(screen_id)
	{
		$(".screen").css( "display", "none" );
		$("#" + screen_id).css( "display", "block" );	
	}
	
	function start_application()
	{
		if(localStorage.getItem("started_time") != null && localStorage.getItem("started_time") > 0)
		{
			show_screen("screen_2");
			$("#start_button").css( "display", "none" );
		}
		else
		{
			show_screen("screen_1");
			$("#stop_button").css( "display", "none" );
			localStorage.setItem("started_time", 0);
		}
		sync_server();
	}
	
	/*
	 * Convert amount of seconds to a string hh:mm:ss
	 */
	function secondsToHms(d) 
	{
		d = Number(d)%(60*60*24);
		var h = Math.floor(d / 3600);
		var m = Math.floor(d % 3600 / 60);
		var s = Math.floor(d % 3600 % 60);
		return ((h > 0 ? h + ":" : "") + (m > 0 ? (h > 0 && m < 10 ? "0" : "") + m + ":" : "0:") + (s < 10 ? "0" : "") + s); 
	}
</script>
</body>
