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
    function index () {
//        $this->redirect("rate");
    }
     function rate(){

         $sql = "SELECT users.name, COUNT( * ) AS win
                    FROM users, battles_detail
                    WHERE users.id = battles_detail.iduser
                    AND battles_detail.result =1
                    GROUP BY users.name
                    ORDER BY win DESC
                    LIMIT 0 , 30" ;
         $data = $this->query($sql);
         $dataChart = $this->query($sql);

         $this->set("data",$data);
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
    function month(){
        $date = $_POST['date'];
        $month = date("m",strtotime($date));
        $year = date("Y",strtotime($date));

        $sql = "SELECT users.name, COUNT( * ) AS win
                    FROM users, battles_detail,battles
                    WHERE users.id = battles_detail.iduser
                    AND battles_detail.result =1
                    and battles_detail.idbattle = battles.id
                    and  MONTH(battles.time) = ".$month."
                    and  year (battles.time) = ".$year."
                    GROUP BY users.name
                    ORDER BY win DESC " ;
        $data =$this->query($sql);
        $dataChart = $this->query($sql);

        $this->set("data",$data);
//
        $chart = new HorizontalBarChart(600, 170);
        $dataSet = new XYDataSet();

        while($row=mysql_fetch_array($dataChart)){
            $dataSet->addPoint(new Point($row[0], $row[1]));
        }
        $chart->setDataSet($dataSet);
        $chart->getPlot()->setGraphPadding(new Padding(5, 30, 20, 140));

        $chart->setTitle("Rank of month ".$month."/".$year);
        $chart->render("../webroot/img/rankmonth.png");
    }

    function year(){
        $year= $_POST['date'];

        $sql = "SELECT users.name, COUNT( * ) AS win
                    FROM users, battles_detail,battles
                    WHERE users.id = battles_detail.iduser
                    AND battles_detail.result =1
                    and battles_detail.idbattle = battles.id
                    and  year (battles.time) = ".$year."
                    GROUP BY users.name
                    ORDER BY win DESC " ;
        $data = $this->query($sql);
        $dataChart =$this->query($sql);

        $this->set("data",$data);
//
        $chart = new HorizontalBarChart(600, 170);
        $dataSet = new XYDataSet();

        while($row=mysql_fetch_array($dataChart)){
            $dataSet->addPoint(new Point($row[0], $row[1]));
        }
        $chart->setDataSet($dataSet);
        $chart->getPlot()->setGraphPadding(new Padding(5, 30, 20, 140));

        $chart->setTitle("Rank of year : ".$year);
        $chart->render("../webroot/img/rankyear.png");
    }
}
