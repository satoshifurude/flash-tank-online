<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo $title_for_layout;?></title>
<?php echo $this->Html->css("style"); // link oi file style.css (app/webroot/css/style.css)?>
<?php $general = $this->Common->general(); // L?y c�c gi� tr? c?a th�nh ph?n tinh : header,footer ?>
</head>
<body>
<div id="top">
    <center><h2><?php echo $general['header']; ?></h2></center>
</div>
<div id="main">
    <div id="menu">
        <?php echo $this->Common->create_menu(); // goi ham tao menu tu common helper?>
    </div>
    <div id="content">
        <div method="post">
        <br><br><br>
            <center>
            <span>Login : <?php echo $this->Session->read("Username");?> | <a href="logout">Logout</a></span>
            <br>
            <br>
            <br>
            <span>Tài khoản: <?php echo  $content['users']['name'] ;?></span>
            <br>
            <span>Lose: <?php echo  $content['users']['lose'] ;?></span>
            <br>
            <span>Win: <?php echo  $content['users']['win'] ;?></span>
            <br>
            <br>
            <input type="submit" name="ok" value="Bắt đầu" />
            </center>
        </div>
    </div>
</div>
<div id="footer">
    <center><?php echo $general['footer'];?></center>
</div>
</body>
</html>
