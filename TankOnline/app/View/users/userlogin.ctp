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
        <ul>
            <li><?php echo $this->Session->read("Username")?>-<?php echo $policy ?></li>
            <li><a href="/TankOnline/users/editlogin">Sửa thông tin</a></li>
            <li><a href="/TankOnline/users/logout">Thoát</a></li>
        </ul>
    </div>
    <div id="content">
        <div>
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
            <span>Họ tên: <?php echo  $content['users']['real_name'] ;?></span>
            <br>
            <span>Sdt: <?php echo  $content['users']['phone_num'] ;?></span>
            <br>
            <span>CMND: <?php echo  $content['users']['cmnd'] ;?></span>
            <br>
            <span>Ngày sinh: <?php echo  $content['users']['birthday'] ;?></span>
            <br>
            <span>Giới tính: <?php echo $content['users']['sex'];?></span>
            <br>
            <span>Địa chỉ: <?php echo  $content['users']['address'] ;?></span>
            <br>
            <span>Email: <?php echo  $content['users']['email'] ;?></span>
            <br>
            <br>
            <form method="post" action="">
            <input type="submit" name="ok" value="Bắt đầu" />
            </form>
            </center>
        </div>
    </div>
</div>
<div id="footer">
    <center><?php echo $general['footer'];?></center>
</div>
</body>
</html>
