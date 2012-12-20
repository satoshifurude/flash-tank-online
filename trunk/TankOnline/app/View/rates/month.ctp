
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
            <?php
                    if($data == null ) {
                         echo "<h2> Error data null </h2>";
                    }else {
                         echo $this->Html->image('rankmonth.png');
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
                            echo"</table>";
                    }
                 ?>
                 <form method="post" action="/TankOnline/rates/month">
                      <label>Xem xếp hạng theo tháng</label>
                      <input type="month" name="date" size="30" width = 60 />
                      <input type=submit value="rank"/>
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