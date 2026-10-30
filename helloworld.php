#!/usr/bin/php
<?php
fwrite(STDOUT, "Hello World!\n");
fwrite(STDOUT, "We can use file functions like fopen(), fread(), fwrite().\n");
fwrite(STDOUT, "For end Users, we use STDIN with fgets(), fread(), fscanf(), fgetc().\n");
fwrite(STDOUT, "Please enter your name:\n");
$name = fgets(STDIN);
fwrite(STDOUT, "Welcome, $name!\n");
fwrite(STDOUT, "Note that fgets gives you the new-line as well!\n");

set_error_handler("ErrorHandler");
function ErrorHandler($errno, $errstr, $errfile, $errline)
{
	fwrite(STDERR,"$errstr in $errfile on $errline\n");
}
$fp = fopen("demo.txt","r");
$str = fread($fp,filesize("demo.txt"));
fwrite(STDOUT, $str . "\n");
fclose($fp);
fwrite(STDOUT, "Task completed successfully!\n");
?>