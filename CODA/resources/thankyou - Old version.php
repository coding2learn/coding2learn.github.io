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
<h2>CODA</h2>
<h3>-Request for data -</h3>
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
$mailsubj = "[CODA] Request and license conditions acceptance";
$mailhead = "From: $email\n";
$mailbody = "CODA corpus download: $fn $ln $email $hp $af";

//$matches = preg_match('/@/', $email);

//print "pregmatch returned $matches";


if ( preg_match('/@/', $email) == 0)
{
	$printstr = "ERROR: invalid email $email" ;
	print $printstr;
}
else
if (  preg_match('/[a-zA-Z]/', $af) == 0)
{
	$printstr = "ERROR: Please enter affiliation" ;
	print $printstr;
}
else
if (  preg_match('/[a-zA-Z]/', $ln) == 0)
{
	$printstr = "ERROR: Please enter last name" ;
	print $printstr;
}
else
{	

	$printstr = "Thank you for providing your information. <br> ";
    $printstr .= '<p><a href="http://coding2learn.github.io/coda/A6135222/CODA-release1.tar.gz">Download CODA corpus</a></p>';
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

}

</script>

</center>
</b>
</font>

</body>
</html>




