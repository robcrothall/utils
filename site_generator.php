#!/usr/bin/php
<?php
$acronym = "SPIC";
$customer_name = "Settlers Park Retirement Village";
$system_name = "Inventory Control";
$sql_file = "sp_admin.sql";
//fwrite(STDOUT, "Enter system acronym: ");
//$acronym = trim(fgets(STDIN));
//fwrite(STDOUT, "Enter Customer name: ");
//$customer_name = trim(fgets(STDIN));
//fwrite(STDOUT, "Enter the system name: ");
//$system_name = trim(fgets(STDIN));
//fwrite(STDOUT, "Enter the name of the SQL file: ");
//$sql_file = trim(fgets(STDIN));

set_error_handler("ErrorHandler");
function ErrorHandler($errno, $errstr, $errfile, $errline)
{
	fwrite(STDERR,"$errstr in $errfile on $errline\n");
}
echo "Generate $system_name ($acronym) from $sql_file for $customer_name (y/n)";
$response = trim(fgets(STDIN));
if ($response == 'y')
{
  $sql = fopen($sql_file,"r");
  $rec_count = 0;
  $end_flush = true;
  $skip_cols = array("id","user_id","changed");
  echo "\n";
  if ($sql)
  {
	while (($str = fgets($sql)) !== false)
	{
		if (preg_match('/^--/', $str)) {continue;}
		if (preg_match('/^\s*$/', $str)) {continue;}
		if (preg_match('/^\/\*\!/', $str)) {continue;}
		if (preg_match('/^SET\s/', $str)) {continue;}
		if (preg_match('/^START\s/', $str)) {continue;}
		if (preg_match('/^COMMIT/', $str)) {continue;}
		if (!$end_flush) {continue;}
		if (preg_match('/^CREATE TABLE/', $str))
		{
			$end_cre8 = false;
			$col_no = 0;
			$key_name = "";
			$col_names = array();
			$start = strpos($str, '`', 0) + 1;
			//echo "Start = $start\n";
			$end = strpos($str, '`', $start) + 1;
			//echo "End = $end\n";
			$table_name = substr($str, $start, $end - $start -1);
			//echo "Table name = [$table_name]\n";
			$module_title = ucfirst($table_name);

			$cre8 = fopen("ctl/" . $table_name . "_create.php", "w");
			fwrite($cre8, "<?php\n");
			fwrite($cre8, "\trequire('../conf/config.php');\n");
			fwrite($cre8, "\t\$_SESSION[\"module\"] = \$_SERVER[\"PHP_SELF\"];\n");
			fwrite($cre8, "\tif (\$_SERVER[\"REQUEST_METHOD\"] == \"POST\")\n");
			fwrite($cre8, "\t{\n");
			fwrite($cre8, "\t  \$error = false;\n");
			fwrite($cre8, "\t  \$message = \"\";\n");
			fwrite($cre8, "\t  \$notes = \"\";\n");
			
			$cre8f = fopen("view/" . $table_name . "_create_form.php", "w");
			fwrite($cre8f, "<h2>Record a new $module_title</h2>\n");
			fwrite($cre8f, "<form action=\"../ctl/$table_name" . "_create.php\" method=\"post\">\n");
			fwrite($cre8f, "\t<table class='table table-hover table-responsive table-bordered'>\n");

			$del = fopen("ctl/" . $table_name . "_delete.php", "w");
			fwrite($del, "<?php\n");
			fwrite($del, "\trequire('../conf/config.php');\n");
			fwrite($del, "\t\$_SESSION[\"module\"] = \$_SERVER[\"PHP_SELF\"];\n");
			fwrite($del, "\tif (\$_SERVER[\"REQUEST_METHOD\"] == \"POST\")\n");
			fwrite($del, "\t{\n");
			fwrite($del, "\t  \$error = false;\n");
			fwrite($del, "\t  \$message = \"\";\n");
			fwrite($del, "\t  \$notes = \"\";\n");
			fwrite($del, "\t\t\$rows = query(\"SELECT count(*) from other_table where foreign_key = ?\", \$_SESSION[\"delete_id\"]);\n");
			
			$delf = fopen("view/" . $table_name . "_delete_form.php", "w");
			fwrite($delf, "<?php\n");
			fwrite($delf, "\t\$_SESSION[\"module\"] = \$_SERVER[\"PHP_SELF\"];\n");
			fwrite($delf, "\t\$delete_id = htmlspecialchars(strip_tags(\$form_id));\n");
			fwrite($delf, "\t\$data = query(\"select * from \$table_name where id = ?\", \$delete_id);\n");
			fwrite($delf, "\t\$_SESSION[\"delete_id\"] = \$delete_id;\n");
			fwrite($delf, "\t\$notes = \$data[0][\"notes\"];\n");
			fwrite($delf, "\t\$user_id = \$data[0][\"user_id\"];\n");
			fwrite($delf, "\t\$changed = \$data[0][\"changed\"];\n");
			fwrite($delf, "\t\$data = query(\"select username from users where id = ?\", \$user_id);\n");
			fwrite($delf, "\t\$username = \$data[0][\"username\"];\n");
			fwrite($delf, "\t\$user_name_given = \$data[0][\"first_name\"] . \" \" . \$data[0][\"surname\"];\n");
			fwrite($delf, "?>\n");
			fwrite($delf, "<h2>This $table_name is about to be deleted!</h2>\n");
  			fwrite($delf, "<div class=\"container\">\n");
  			fwrite($delf, "<form action=\"../ctl/$table_name" . "_delete.php\" method=\"post\">\n");
   		fwrite($delf, "\t<table border=\"0\" cellpadding=\"0\" cellspacing=\"10\" width=\"100%\">\n");
			fwrite($delf, "\t\t<tr>\n");
			fwrite($delf, "\t\t\t<td align=\"right\" width=\"30%\">Name:</td>\n");
			fwrite($delf, "\t\t\t<td width=\"2%\"></td>\n");
			fwrite($delf, "\t\t\t<td align=\"left\" width=\"70%\"><?php echo $table_name; ?></td>\n");
			fwrite($delf, "\t\t</tr>\n");

			continue;
		}
		if (preg_match('/;/', $str))
		{
			$end_cre8 = true;
			$end_flush = true;
			fwrite($cre8, "\t  \$rows = query(\"select count(*) rowCount from $table_name where $key_name=?\", \$$key_name);\n");
			fwrite($cre8, "\t  \$row = \$rows[0];\n");
			fwrite($cre8, "\t  if (\$row[\"rowCount\"] > 0) {\$message .= \"[$key_name] already exists in our records.\"; \$error = true;}\n");
			fwrite($cre8, "\t  if (\$error == false)\n");
			fwrite($cre8, "\t  {\n");
			fwrite($cre8, "\t\t\$sql_stmt = \"insert into $table_name (");
			foreach ($col_names as $work)
			{fwrite($cre8, "$work, ");}
			fwrite($cre8, "user_id");
			fwrite($cre8, ") values (");
			foreach ($col_names as $work)
			{fwrite($cre8, "?, ");}
			fwrite($cre8, "\$_SESSION[\"id\"]);\n");
			fwrite($cre8, "\t\t\$rowCount = query(\$sql_stmt");
			foreach ($col_names as $work)
			{fwrite($cre8, ", \$$work");}
			fwrite($cre8, ");\n");
			fwrite($cre8, "\t\tif (\$rowCount == false) {\$message .= \"Record inserted successfully.\";}\n");
			fwrite($cre8, "\t\telse {\$message .= \"Failed to add the record - please call support!\";}\n");
			fwrite($cre8, "\t  }\n");
			fwrite($cre8, "\t  render(\"../view/$table_name" . "_form.php\", [\"title\" => \"List of $table_name\", \"message\" => \"\$message\"]);\n");
			fwrite($cre8, "\t}\n");
			fwrite($cre8, "\telse\n");
			fwrite($cre8, "\t{\n");
			fwrite($cre8, "\t\trender(\"../view/$table_name" . "_create_form.php\", [\"title\" => \"Record details of another $table_name\"]);\n");
			fwrite($cre8, "\t}\n");
			fwrite($cre8, "?>");
			fclose($cre8);

			fwrite($cre8f,"\t</table>\n");
			fwrite($cre8f,"</form>\n");
			fclose($cre8f);
			

			fwrite($del, "\t\$rows = query(\"DELETE from $table_name where id = ?\", \$_SESSION[\"delete_id\"]);\n");
			fwrite($del, "\t\$message = \"Selected record has been deleted.\";\n");
			fwrite($del, "\trender(\"../view/$table_name" . "_form.php\", [\"message\" => \$message]);\n");
			fwrite($del, "\t}\n");
			fwrite($del, "\telse\n");
			fwrite($del, "\t{\n");
			fwrite($del, "\t\$id = \$_REQUEST[\"id\"];\n");
			fwrite($del, "\trender(\"../view/$table_name" . "_delete_form.php\", [\"title\" => \"Delete a \$table_name\",\n");
			fwrite($del, "\t\t\"form_id\" => \"\$id\"]);\n");
			fwrite($del, "\t}\n");
			fwrite($del, "?>\n");
			fclose($del);

			fwrite($delf, "\t\t<tr>\n");
			fwrite($delf, "\t\t/t<td align=\"right\" width=\"25%\">Changed by:</td>\n");
			fwrite($delf, "\t\t/t<td width=\"2%\"></td>\n");
			fwrite($delf, "\t\t\t<td align=\"left\" width=\"70%\"><?php echo \$username; ?></td>\n");
			fwrite($delf, "\t\t</tr>\n");
			fwrite($delf, "\t\t<tr>\n");
			fwrite($delf, "\t\t\t<td align=\"right\" width=\"25%\">Changed on:</td>\n");
			fwrite($delf, "\t\t\t<td width=\"2%\"></td>\n");
			fwrite($delf, "\t\t\t<td align=\"left\" width=\"70%\"><?php echo \$changed; ?></td>\n");
			fwrite($delf, "\t\t</tr>\n");
			fwrite($delf, "\t\t<tr>\n");
			fwrite($delf, "\t\t/t<td align=\"right\" width=\"25%\">Notes:</td>\n");
			fwrite($delf, "\t\t/t<td width=\"2%\"></td>\n");
			fwrite($delf, "\t\t\t<td align=\"left\" width=\"70%\"><?php echo \$notes; ?></td>\n");
			fwrite($delf, "\t\t</tr>\n");
			fwrite($delf, "\t</table>\n");
			fwrite($delf, "<h3>This $table_name is used by the following XXXXX - they need to be deleted first!</h3>\n");
			fwrite($delf, "<table class=\"table table-striped table-bordered\">\n");
			fwrite($delf, "\t<thead>\n");
			fwrite($delf, "\t\t<tr>\n");
			fwrite($delf, "\t\t\t<th>XXXXX</th>\n");
			fwrite($delf, "\t\t</tr>\n");
			fwrite($delf, "\t</thead>\n");
			fwrite($delf, "\t<tbody>\n");
			fwrite($delf, "<?php\n");
			fwrite($delf, "\t\$rows = query(\"SELECT * from regions where country_id = ? order by region\", \$country_id);\n");
			fwrite($delf, "\tif (count(\$rows) > 0)\n");
			fwrite($delf, "\t{\n");
			fwrite($delf, "\t\tforeach (\$rows as \$row)\n");
			fwrite($delf, "\t\t{\n");
			fwrite($delf, "\t\t\techo \"<tr>\";\n");
			fwrite($delf, "\t\t\techo \"<td>\" . \$row[\"region\"] . \"</td>\";\n");
			fwrite($delf, "\t\t\techo \"</tr>\";\n");
			fwrite($delf, "\t\t}\n");
			fwrite($delf, "\t}\n");
			fwrite($delf, "\telse \n");
			fwrite($delf, "\t{\n");
			fwrite($delf, "\t\techo \"<tr><td>No dependent regions</td></tr>\";\n");
			fwrite($delf, "\t}\n");
			fwrite($delf, "?>\n");
			fwrite($delf, "\t</tbody>\n");
			fwrite($delf, "</table>\n");
			fwrite($delf, "<div class=\"form-actions\">\n");
			fwrite($delf, "\t<input type=\'submit\' value=\'Delete\' class=\'btn btn-danger\' />\n");
			fwrite($delf, "\t<a class=\"btn btn-success\" href=\"../ctl/country.php\">Cancel</a>\n");
			fwrite($delf, "</div>\n");
			fwrite($delf, "</form>\n");
			fclose($delf);
			
			continue;
		}
		if (!$end_cre8)
		{
			$start = strpos($str, '`', 0) + 1;
			//echo "Start = $start\n";
			$end = strpos($str, '`', $start) + 1;
			//echo "End = $end\n";
			$col_name = substr($str, $start, $end - $start - 1);
			//echo "Column name = [$col_name]\n";
			$start = $end + 1;
			//echo "Start = $start\n";
			$end = strpos($str, ' ', $start) + 1;
			if ($start > $end) {$end = strpos($str, ',', $start) + 1;}
			//echo "End = $end\n";
			$work = substr($str, $start, $end - $start - 1);
			//echo "Work field = [$work]\n";
			$end = strpos($work, "(");
			if ($end == 0)
			{
				$type = $work;
			}
			else
			{
				$type = substr($work, 0, $end);
			}
			//echo "[$col_name] is type [$type]\n";
			$col_no += 1;
			if ($col_no == 2)
			{
				$key_name = $col_name;
			}
			//echo "[$key_name] is type [$type]\n";
			if (in_array($col_name, $skip_cols)) {continue;}
			array_push($col_names, $col_name);
			//print_r($col_names);
			$work = preg_replace('/_/', ' ', $col_name);
			$work = ucwords($work);
			fwrite($cre8, "\t  \$$col_name = \"\";\n");
			fwrite($cre8, "\t  if (\$_POST[\"$col_name\"] == '') {\$message .= \"You must provide $work.  \"; \$error = true;}\n");
			fwrite($cre8, "\t  else {\$$col_name = trim(htmlspecialchars(\$_POST[\"$col_name\"]));\n");
			//--------------------------------------
			fwrite($cre8f, "\t\t<tr>\n");
			fwrite($cre8f, "\t\t\t<td>$work</td>\n");
			if ($type == "text")
			{
				fwrite($cre8f, "\t\t\t<td><textarea name=\"$col_name\" class=\"form_control\"></textarea></td>\n");
			}
			elseif ($type == "int")
			{
				fwrite($cre8f, "\t\t\t<td><input name=\"$col_name\" type=\"number\" class=\"form_control\"></td>\n");
			}
			elseif ($type == "date")
			{
				fwrite($cre8f, "\t\t\t<td><input name=\"$col_name\" type=\"date\" class=\"form_control\"></td>\n");
			}
			else
			{
				fwrite($cre8f, "\t\t\t<td><input name=\"$col_name\" type=\"text\" class=\"form_control\"></td>\n");
			}
			fwrite($cre8f, "\t\t</tr>\n");
		}
		if (preg_match('/^ALTER/', $str))
		{
			$end_flush = false;
			continue;
		}
		//fwrite(STDOUT, $str);
		$rec_count += 1;

	}
	if (!feof($sql))
	{
		fwrite(STDERR, "Failed to read to end of file\n");
	}
	fclose($sql);
	// Now for standard modules - header, footer,menu, login, logoff, register, etc.
	$fil = fopen("view/footer.php", "w");
	fclose($fil);

	$fil = fopen("view/header.php", "w");
	fclose($fil);

	$fil = fopen("view/menu.php", "w");
	fclose($fil);

	$fil = fopen("ctl/login.php", "w");
	fwrite($fil, "<?php\n");
	fwrite($fil, "require(\"../conf/config.php\");\n");
	fwrite($fil, "\$_SESSION[\"module\"] = \$_SERVER[\"PHP_SELF\"];\n");
	fwrite($fil, "\$_SESSION[\"id\"] = \"0\";\n");
	fwrite($fil, "\$_SESSION[\"username\"] = \"Unknown\";\n");
	fwrite($fil, "\$_SESSION[\"user_first_name\"] = \"\";\n");
	fwrite($fil, "\$_SESSION[\"user_surname\"] = \"Unknown\";\n");
	fwrite($fil, "\$_SESSION[\"member_exp\"] = \"Unknown\";\n");
	fwrite($fil, "\$_SESSION[\"search_count\"] = \"0\";\n");
	fwrite($fil, "\$_SESSION[\"search_date\"] = \"\";\n");
	fwrite($fil, "\$_SESSION[\"user_role\"] = \"Visitor\";\n");
	fwrite($fil, "\$_SESSION[\"selected_people_id\"] = 0;\n");
	fwrite($fil, "\$_SESSION[\"search_name_start\"] = \"\";\n");
	fwrite($fil, "if (\$_SERVER[\"REQUEST_METHOD\"] == \"POST\")\n");
	fwrite($fil, "{\n");
	fwrite($fil, "\tif (empty(\$_POST[\"username\"]))\n");
	fwrite($fil, "\t{\n");
	fwrite($fil, "\t\tapologize(\"You must provide your username.\");\n");
	fwrite($fil, "\t}\n");
	fwrite($fil, "\telse if (empty(\$_POST[\"password\"]))\n");
	fwrite($fil, "\t{\n");
	fwrite($fil, "\t\tapologize(\"You must provide your password.\");\n");
	fwrite($fil, "\t}\n");
	fwrite($fil, "\t\$user_name_given = \$_POST[\"username\"];\n");
	fwrite($fil, "\t\$password_given = \$_POST[\"password\"];\n");
	fwrite($fil, "\t\$rows = query(\"SELECT * FROM users WHERE username = ?\", \$user_name_given);\n");
	fwrite($fil, "\tif (count(\$rows) == 1)\n");
	fwrite($fil, "\t{\n");
	fwrite($fil, "\t\t\$row = \$rows[0];\n");
	fwrite($fil, "\t\tif (crypt(\$_POST[\"password\"], \$row[\"hash\"]) == \$row[\"hash\"])\n");
	fwrite($fil, "\t\t{\n");
	fwrite($fil, "\t\t\t\$_SESSION[\"id\"] = \$row[\"id\"];\n");
	fwrite($fil, "\t\t\t\$_SESSION[\"username\"] = \$row[\"username\"];\n");
	fwrite($fil, "\t\t\t\$_SESSION[\"user_first_name\"] = \$row[\"first_name\"];\n");
	fwrite($fil, "\t\t\t\$_SESSION[\"user_surname\"] = \$row[\"surname\"];\n");
	fwrite($fil, "\t\t\t\$_SESSION[\"member_exp\"] = \$row[\"member_exp\"];\n");
	fwrite($fil, "\t\t\t\$_SESSION[\"search_count\"] = \$row[\"search_count\"];\n");
	fwrite($fil, "\t\t\t\$_SESSION[\"search_date\"] = \$row[\"search_date\"];\n");
	fwrite($fil, "\t\t\t\$_SESSION[\"user_role\"] = \$row[\"user_role\"];\n");
	fwrite($fil, "\t\t\t\$success = TRUE;\n");
	fwrite($fil, "\t\t\tlogin_log(\$user_name_given, \$password_given, \$success);\n");
	fwrite($fil, "\t\t\t\$today = date(\"Y-m-d\");\n");
	fwrite($fil, "\t\t\tif (\$_SESSION[\"search_date\"] != \$today)\n");
	fwrite($fil, "\t\t\t{\n");
	fwrite($fil, "\t\t\t\t\$_SESSION[\"search_date\"] = \$today;\n");
	fwrite($fil, "\t\t\t\t\$_SESSION[\"search_count\"] += 1;\n");
	fwrite($fil, "\t\t\t\t\$rows = query(\"update users set search_count = ?, search_date = ? where id = ?\", \$_SESSION[\"search_count\"], \$_SESSION[\"search_date\"], \$_SESSION[\"id\"]);\n");
	fwrite($fil, "\t\t\t}\n");
	fwrite($fil, "\t\t\tredirect(\"../ctl/search.php\");\n");
	fwrite($fil, "\t\t\t}\n");
	fwrite($fil, "\t\t}\n");
	fwrite($fil, "\t\t\$success = FALSE;\n");
	fwrite($fil, "\t\tlogin_log(\$user_name_given, \$password_given, \$success);\n");
	fwrite($fil, "\t\tapologize(\"Invalid username and/or password.\");\n");
	fwrite($fil, "\t}\n");
	fwrite($fil, "\telse\n");
	fwrite($fil, "\t{\n");
	fwrite($fil, "\t\trender(\"../view/login_form.php\", [\"title\" => \"Log In\"]);\n");
	fwrite($fil, "\t}\n");
	fwrite($fil, "?>\n");
	fclose($fil);

	$fil = fopen("ctl/logout.php", "w");
	fwrite($fil, "<?php\n");
	fwrite($fil, "\trequire(\"../conf/config.php\");\n"); 
	fwrite($fil, "\tlogout();\n");
	fwrite($fil, "\trender(\"../view/login_form.php\", [\"title\" => \"Log In\"]);\n");
	fwrite($fil, "?>\n");

	fclose($fil);

	$fil = fopen("ctl/register.php", "w");
	fclose($fil);

  }
}
fwrite(STDOUT, "Total records read - $rec_count\n");
fwrite(STDOUT, "Task completed successfully!\n");
?>