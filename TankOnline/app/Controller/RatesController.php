<?php
/**
 * Created by JetBrains PhpStorm.
 * User: ThanhTri
 * Date: 12/19/12
 * Time: 10:25 PM
 * To change this template use File | Settings | File Templates.
 */
include "../libchart/libchart/classes/libchart.php";
class RatesController extends AppController
{
     function rate(){
         $conn=mysql_connect("localhost","root","") or die("can't connect this database");
         mysql_select_db("tank_db",$conn);

         $sql = "SELECT users.name, COUNT( * ) AS win
                    FROM users, battles_detail
                    WHERE users.id = battles_detail.iduser
                    AND battles_detail.result =1
                    GROUP BY users.name
                    ORDER BY win DESC
                    LIMIT 0 , 30" ;
         $data = mysql_query($sql);
//         $data=mysql_fetch_array($query);
         $dataChart = mysql_query($sql);

         $this->set("data",$data);
//
         $chart = new HorizontalBarChart(600, 170);
         $dataSet = new XYDataSet();

         while($row=mysql_fetch_array($dataChart)){
             $dataSet->addPoint(new Point($row[0], $row[1]));
         }
         $chart->setDataSet($dataSet);
         $chart->getPlot()->setGraphPadding(new Padding(5, 30, 20, 140));

         $chart->setTitle("Rank");
         $chart->render("../webroot/img/rank.png");
     }
}
