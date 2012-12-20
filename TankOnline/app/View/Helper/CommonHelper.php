<?php
class CommonHelper extends HtmlHelper {
// H�m t?o menu
    var $helpers = array("Session","Html","Common","Flash");
//    var $helpers = array();
    function create_menu(){

        $menu  = "<ul>";
        $menu .= "<li>".$this->link("Đăng nhập", array(
            "controller"=>"users",
            "action"=>"login"))."</li>";
        $menu .= "<li>".$this->link("Đăng Kí", array(
            "controller"=>"users",
            "action"=>"register"))."</li>";
        $menu .= "</ul>";
        return $menu;
    }
    function  create_menu_report ()    {
        $menu  = "<ul>";
        $policy = $this->Session->read('Policy')  ;
        switch ($policy){
            case 4:
            case 3:
            $menu .= "<li>".$this->link("Báo cáo theo giới tính", array(
                    "controller"=>"reports",
                    "action"=>"sex"))."</li>";
            $menu .= "<li>".$this->link("Báo cáo theo độ tuổi", array(
                    "controller"=>"reports",
                    "action"=>"age"))."</li>";
            $menu .= "<li>".$this->link("Số trận đấu ", array(
                    "controller"=>"reports",
                    "action"=>"battles"))."</li>";
            case 2:
                $menu .= "<li>".$this->link("Xếp hạng", array(
                    "controller"=>"rates",
                    "action"=>"rate"))."</li>";
                $menu .= "<li>".$this->link("Xếp hạng theo tháng", array(
                    "controller"=>"rates",
                    "action"=>"month"))."</li>";
                $menu .= "<li>".$this->link("Xếp hạng theo năm", array(
                    "controller"=>"rates",
                    "action"=>"year"))."</li>";
            case 1:
                $menu .= "<li>".$this->link("Xếp hạng", array(
                    "controller"=>"rates",
                    "action"=>"rate"))."</li>";
                $menu .= "<li>".$this->link("Home", array(
                    "controller"=>"users",
                    "action"=>"login"))."</li>";
                break;
            default:
                $menu .= "<li>".$this->link("Đăng nhập", array(
                    "controller"=>"users",
                    "action"=>"login"))."</li>";
                $menu .= "<li>".$this->link("Đăng Kí", array(
                    "controller"=>"users",
                    "action"=>"register"))."</li>";
        }
        $menu .= "</ul>";
        return $menu;
    }
//H�m t?o c�c th�nh ph?n cho header v� footer
    function general(){
        $data = array(
            "header" => "Tank Online",
            "footer" => "<br>09520185 - 09520158 - 09520320<br>Web Game Tank",
        );
        return $data;
    }
}
