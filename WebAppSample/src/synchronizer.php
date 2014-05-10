<?php
	session_start();
	if(isSet($_REQUEST['actions']))
	{
		$_SESSION['actions_list'] .= $_REQUEST['actions'];
	}
?>