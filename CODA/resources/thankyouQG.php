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
<h2>QGSTEC2010 Generating Questions from Sentences Corpus</h2>
<h3>-Download page -</h3>
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
$af = $_POST[affi];
$mailto = "MCT-CODA-Project@open.ac.uk";
$mailsubj = "[CODA-QG] Request and license conditions acceptance";
$mailhead = "From: $email\n";
$mailbody = "CODA corpus download: $af";

//$matches = preg_match('/@/', $email);

//print "pregmatch returned $matches";



	
    $printstr .= '<p><a href="http://computing.open.ac.uk/coda/Q1928369/QGSTEC-Sentences-2010.zip">Download QGSTEC corpus</a></p>';
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



