<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8"/>
	<title>Tank Online</title>
	<meta name="description" content="" />
	
	<script src="swfobject.js"></script>
	<script>
		var flashvars = {
		};
		var params = {
			menu: "false",
			scale: "noScale",
			allowFullscreen: "true",
			allowScriptAccess: "always",
			bgcolor: "",
			wmode: "gpu" // can cause issues with FP settings & webcam
		};
		var attributes = {
			id:"tank",
			align:"absmiddle",
		};
		swfobject.embedSWF(
			"tank.swf", 
			"altContent", "800", "600", "11", 
			"expressInstall.swf", 
			flashvars, params, attributes);
	</script>
	<style>
		html, body { height:100%; overflow:hidden; }
		body { margin:0; }
	</style>
</head>
<body>
	<table align="center" cellpadding="0"  cellspacing="0" border="0" >
    <tr align="center">
        <td align="center" >
            <div id="altContent">
				<h1>Tank Online</h1>
				<p><a href="http://www.adobe.com/go/getflashplayer">Get Adobe Flash player</a></p>
				
			</div>
        </td>
    </tr>
</table>
</body>
</html>