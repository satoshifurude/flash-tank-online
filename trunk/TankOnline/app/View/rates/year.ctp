<html>
<header>
</header>
<body>
    <div id="menu" ">
        <b>Menu</b><br>
        <?php echo $this->Common->create_menu_report(); ?>
    </div>
    <div id="content" ">
     <?php
        if($data == null ) {
             echo "<h2> Error data null </h2>";
        }else {
             echo $this->Html->image('rankyear.png');
              echo"<table>
                    <tr>
                        <td> Rate </td>
                        <td> User Name </td>
                        <td> Win </td>
                    </tr> ";
                 $index = 1;
                while($row=mysql_fetch_array($data)){
                          echo "<tr>";
                          echo "<td>$index</td>";
                          echo "<td>$row[0]</td>";
                          echo "<td>$row[1]</td>";
                          echo "</tr>";
                          $index++;
                }
        }
     ?>
      </div>
     <div id="content" ">
     <form method="post" action="/TankOnline/rates/year">
           <label>Xem xếp hạng theo năm</label>
           <input type="num" name="date" size="30" />
           <input type=submit value="rank"/>
      </form>
      </div>
</body>
</html>