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
            <li><a href="/TankOnline/rates/index">Xem xếp hạng</a></li>
            <li><a href="/TankOnline/users/logout">Thoát</a></li>
        </ul>
    </div>
    <div id="content">
    <center>
    <br><center><h2>Quản lí thành viên</h2></center><br>
    <span class="error"><?php echo $error; ?></span>
        <div>
            <table align='center' width='500' border='1'>
            <tr align='center'>
                <td>ID</td>
                <td>Tên tài khoản</td>
                <td>Chức vụ</td>
                <td>Edit</td>
            </tr>
                <?php foreach ($data as $info): ?>
            <tr align='center'>
                 <td><?php echo $info['users']['id']; ?></td>
                 <td><?php echo $info['users']['name']; ?></td>
                 <?php if ($info['users']['policy'] == 1) {?>
                 <td>Thành viên</td>
                 <?php } else if ($info['users']['policy'] == 2) {?>
                 <td>GM</td>
                 <?php }?>
                 <td><a href="edituserandgm/<?php echo $info['users']['name']; ?>">Edit</a></td>
            </tr>
                   <?php endforeach; ?>
            </table>
        </div>
    </center>
    </div>
</div>
<div id="footer">
    <center><?php echo $general['footer'];?></center>
</div>
</body>
</html>
