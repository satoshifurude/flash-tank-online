<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo $title_for_layout;?></title>
<?php echo $this->Html->css("web"); // link oi file style.css (app/webroot/css/style.css)?>
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
            <li><a href="/TankOnline/users/login">Xem thông tin</a></li>
            <li><a href="/TankOnline/users/manageusers">Quản lí thành viên</a></li>
            <li><a href="/TankOnline/rates/index">Xem xếp hạng</a></li>
            <li><a href="/TankOnline/users/logout">Thoát</a></li>
        </ul>
    </div>
    <div id="content">
        <div>
        <br><center><h2>Sửa thông tin tài khoản</h2></center><br>
            <center>
            <form method="post" action="">
                <label>Họ và tên </label><br><input type="text" name="hoten" size="30" /><br />
                <label>Số điện thoại </label><br><input type="text" name="sdt" size="30" /><br />
                <label>Cmnd </label><br><input type="text" name="cmnd" size="30" /><br />
                <label>Ngày sinh </label><br><input type="date" name="ngaysinh" size="30" /><br />
                <label>Giới tính </label><br><input type="radio" name="nam" size="30" value="Nam" checked />Nam<input type="radio" name="nam" size="30" value="Nu" />Nữ<br />
                <label>Địa chỉ </label><br><input type="text" name="diachi" size="30" /><br />
                <label>Email </label><br><input type="text" name="email" size="30" /><br />
                <label>&nbsp;</label><input type="submit" name="ok" value="Sửa" />
                <!—Hiển  thị thông báo lỗi nếu có-->
                <br>
                <span class="error"><?php echo $error; ?></span>
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

