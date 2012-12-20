<html>
<header>
</header>
<body>
    <div id="menu" ">
        <b>Menu</b><br>
        <?php echo $this->Common->create_menu_report(); ?>
    </div>
     <?php
         echo $this->Html->image('battlesmonth.png');
         echo $this->Html->image('battlesyear.png');
     ?>
      <div id="content" ">
          <form method="post" action="/TankOnline/reports/battles">
                   <label>Xem xếp hạng theo tháng</label>
                   <input type="month" name="date" size="30" width = 60 />
                   <input type=submit value="report"/>
           </form>
       </div>
</body>
</html>