<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>
<head>
<title>CODA Home Pages</title>
</head>

<body bgcolor="#FFFFFF">
<table border=0 bgcolor="#000066" width=100% cellpadding=1>
<tr align=right><td>
<FONT size="+1" color="#FFFFFF" FACE="arial,helvetica,sans-serif"><b></b></FONT>
</td></tr>
</table>

<table border=0 bgcolor="#FFFFFF" width=100% cellpadding=10>
<tr><td>
<p>
<center>
<h2>CODA Tools</h2>
<h3>-Request for CODA Software -</h3>
</center>
</p>
</td></tr>
</table>

<table border=0 bgcolor="#000066" width=100% cellpadding=1>
<tr align=right><td>
<FONT size="+1" color="#FFFFFF" FACE="arial,helvetica,sans-serif"><b></b></FONT>
</td></tr>
</table>
<br>
<br>
<br>
<font face="arial,helvetica,sans-serif" size="+1">
<b>
<center>


<script language="php">
$email = $_POST[email];
$fn = $_POST[firstname];
$ln = $_POST[lastname];
$hp = $_POST[homepage];
$af = $_POST[affi];
$mailto = "MCT-CODA-Project@open.ac.uk";
$mailsubj = "[CODA-Tools] Download";
$mailbody = "CODA Tools download: $af";

//$matches = preg_match('/@/', $email);

//print "pregmatch returned $matches";


	


    $printstr .= '<p><a href="http://coding2learn.github.io/coda/resources/CODA-Software-V1.1.zip">Download CODA Tools</a></p>';
	print $printstr;
	
	include 'include/custom_header.php';

		//reset ($HTTP_POST_VARS);

	mail ($mailto, 
		  $mailsubj,
		  $mailbody,
		  $mailhead);

	
/*	$filepath = "\\\\penelope\\Faculty_WebSites\\computing\\coda\\resources\\";
	$filename = "test.zip";
	$file = $filepath . $filename;
	print "\n<a href>file is $file";
*/
     
 
     //CREATE/OUTPUT THE HEADER
   /*  header("Content-type: application/force-download");
     header("Content-Transfer-Encoding: Binary");
     header("Content-length: ".filesize($file));
     header("Content-disposition: attachment; filename=\"".basename($file)."\"");
     readfile($file);
*/

	//CODACORPUS1.0.zip



</script>

</center>
</b>
</font>

</body>
</html>




