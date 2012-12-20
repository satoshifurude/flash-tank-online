<?php
/**
 * Created by JetBrains PhpStorm.
 * User: ThanhTri
 * Date: 12/20/12
 * Time: 11:19 AM
 * To change this template use File | Settings | File Templates.
 */
include "../libchart/libchart/classes/libchart.php";
class ReportsController  extends AppController
{

    var $helpers = array("Html","Common","Flash");
    var $component = array("Session");
    function sex (){
        if($this->Session->read('Policy')<=2){
            $this->redirect(array('controller' => 'users', 'action' => 'login'));
            return;
        }


        $sqlCountUser = "select count(*) from users ";
        $sqlCountMale = "select count(*) from users	where users.sex = 1" ;
        $sqlCountFemale = "select count(*) from users	where users.sex = 2" ;

        $dataCountUser = $this->query ( $sqlCountUser) ;
        $dataCountMale = $this->query ( $sqlCountMale) ;
        $dataCountFemale = $this->query ( $sqlCountFemale) ;

        $rowUser = mysql_fetch_array($dataCountUser) ;
        $rowMale = mysql_fetch_array($dataCountMale) ;
        $rowFemale = mysql_fetch_array($dataCountFemale) ;

        $countUser = $rowUser[0];
        $countMale = $rowMale[0];
        $countFemale = $rowFemale[0];
        $countUnknow = $countUser - ($countMale+$countFemale);

        $chart = new PieChart();
        $dataSet = new XYDataSet();
        $dataSet->addPoint(new Point("Male (".$countMale.")", $countMale));
        $dataSet->addPoint(new Point("Female (".$countFemale.")", $countFemale));
        $dataSet->addPoint(new Point("Unknow (".$countUnknow.")", $countUnknow));
        $chart->setDataSet($dataSet);
        $chart->setTitle("Report sex");
        $chart->render("../webroot/img/sex.png");
    }
    function age () {
        if($this->Session->read('Policy')<=2){
            $this->redirect(array('controller' => 'users', 'action' => 'login'));
            return;
        }
        $sqlage =  "SELECT YEAR( CURRENT_DATE( ) ) - YEAR( users.birthday ) AS age, COUNT( * ) AS count
                        FROM users
                        GROUP BY (
                        YEAR( CURRENT_DATE( ) ) - YEAR( users.birthday )
                        )" ;
        $data = $this->query($sqlage);
        $chart = new PieChart();
        $dataSet = new XYDataSet();
        while ($row = mysql_fetch_array($data) )   {
            $dataSet->addPoint(new Point("Age :".$row[0]."(".$row[1].")", $row[1]));
        }
        $chart->setDataSet($dataSet);
        $chart->setTitle("Report age");
        $chart->render("../webroot/img/age.png");
    }
    function battles () {
        if($this->Session->read('Policy')<=2){
            $this->redirect(array('controller' => 'users', 'action' => 'login'));
            return;
        }
        if(isset($_POST['date'])){
            $date =$_POST['date'];
        }else {
            $date = date_default_timezone_get();
        }
        $month = date("m",strtotime($date));
        $year = date("Y",strtotime($date));

        $sql =   "select DAY(battles.time), count(*)
                        from battles
                        where YEAR(battles.time) = ".$year."
                        and MONTH(battles.time) = ".$month."
                        GROUP BY DAY(battles.time)  ";

        $sqlYear =   "select  MONTH(battles.time), count(*)
                        from battles
                        where YEAR(battles.time) = ".$year."
                        GROUP BY  MONTH(battles.time)  ";

        $data = $this->query($sql);
        $dataYear = $this->query($sqlYear);

        $days = $this->createDays($month,$year);
        $days = $this->updateDate($days,$data);
        $months = $this->createMonth();
        $months = $this->updateDate($months,$dataYear);

        $chart = new VerticalBarChart(800,400);
        $dataSet = new XYDataSet();
        for($i = 1; $i<count($days);$i++) {
            $dataSet->addPoint(new Point($i, $days[$i]));
        }
        $chart->setDataSet($dataSet);
        $chart->setTitle("Battles create in ".$month."/".$year);
        $chart->render("../webroot/img/battlesmonth.png");

        $chartYear = new VerticalBarChart(800,400);
        $dataSetYear = new XYDataSet();
        echo "Month : ".count($months);
        for($i = 1; $i<count($months);$i++) {
            $dataSetYear->addPoint(new Point($i, $months[$i]));
        }
        $chartYear->setDataSet($dataSetYear);
        $chartYear->setTitle("Battles create in year ".$year);
        $chartYear->render("../webroot/img/battlesyear.png");
    }
    // tao mang tat ca cac ngay trong thang voi gia tri = 0
    function createDays ($month,$year) {
        $result = array(0) ;
        $date = 31; // sẽ tinh lại cho đung

        for($i = 0;$i < $date ; $i++){
            array_push($result,0);
        }
        return $result;
    }
    function updateDate($value,$data) {
        while($row = mysql_fetch_array($data)){
            $value[$row[0]] = $row[1];
        }
       return $value;
    }
    function createMonth(){
        $result = array(0) ;
        for($i = 0;$i < 12 ; $i++){
            array_push($result,0);
        }
        return $result;
    }
}
