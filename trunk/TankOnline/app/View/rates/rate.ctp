<html>
<header>
</header>
<body>
     <div id="menu" ">
            <b>Menu</b><br>
            <?php echo $this->Common->create_menu_report(); ?>
    </div>
     <?php
        if($data == null ) {
             echo "<h2> Error data null </h2>";
        }else {
             echo $this->Html->image('rank.png');
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
</body>
</html>