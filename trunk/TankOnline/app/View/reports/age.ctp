<html>
<header>
</header>
<body>
    <div>
    <div id="menu" align="left">
        <?php echo $this->Common->create_menu_report(); // goi ham tao menu tu common helper?>
    </div>
    <div id="content" align="center">
         <?php
             echo $this->Html->image('age.png');
         ?>
          </br>
          Thông tin về độ tuổi user đã đăng ký
    </div>

</body>
</html>