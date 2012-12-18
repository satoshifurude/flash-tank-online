<?php
class CommonHelper extends HtmlHelper {
// H�m t?o menu
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
//H�m t?o c�c th�nh ph?n cho header v� footer
    function general(){
        $data = array(
            "header" => "Tank Online",
            "footer" => "<br>09520185 - 09520158 - 09520320<br>Web Game Tank",
        );
        return $data;
    }
}
