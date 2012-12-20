<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<?php echo $this->Html->css("web"); // link oi file style.css (app/webroot/css/style.css)?>
<?php $general = $this->Common->general(); // L?y c�c gi� tr? c?a th�nh ph?n tinh : header,footer ?>
</head>
<body>
<div id="top">
    <center><h2><?php echo $general['header']; ?></h2></center>
</div>
<div id="main">
    <div id="menu">
        <?php echo $this->Common->create_menu_report(); ?>
    </div>
    <div id="content">
    <center>
        <div>
            <h2>Xếp hạng</h2>
            </br></br></br></br>
            <form method = "post" action = "/TankOnline/rates/rate">
                 <label>Xem xếp hạng của toàn bộ user </label>
                 <input type=submit value="Xem"/>
            </form>
                      </br>
                      </br>
            <form method="post" action="/TankOnline/rates/month">
                  <label>Xem xếp hạng theo tháng</label><br>
                  <input type="date" name="date" size="30" width = 60 />
                  <input type=submit value="Xem"/>
            </form>
                      </br>
                      </br>
            <form method="post" action="/TankOnline/rates/year">
                  <label>Xem xếp hạng theo năm</label><br>
                  <input type="num" name="date" size="30" />
                  <input type=submit value="Xem"/>
            </form>
        </div>
    </center>
    </div>
</div>
<div id="footer">
    <center><?php echo $general['footer'];?></center>
</div>
</body>
</html>
