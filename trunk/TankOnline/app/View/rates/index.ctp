<!DOCTYPE html>
<html>
<body>

<div id="container">
    <div id="menu" ">
        <b>Menu</b><br>
        <?php echo $this->Common->create_menu_report(); ?>
    </div>
        <div id="content" aglin="right" style="background-color:#EEEEEE;height:800px;width:400px;">
             </br>
             </br>
            <form method = "post" action = "/TankOnline/rates/rate">
                 <label>Xem xếp hạng của toàn bộ user </label>
                <input type=submit value="rank"/>
              </form>
              </br>
              </br>
             <form method="post" action="/TankOnline/rates/month">
                 <label>Xem xếp hạng theo tháng</label>
                 <input type="date" name="date" size="30" width = 60 />
                 <input type=submit value="rank"/>
             </form>
              </br>
              </br>
            <form method="post" action="/TankOnline/rates/year">
                  <label>Xem xếp hạng theo năm</label>
                  <input type="num" name="date" size="30" />
                  <input type=submit value="rank"/>
             </form>
        </div>
    </div>
</body>
</html>