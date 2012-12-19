<?php
class UsersController extends AppController {
    var $layout = false; // Không sử dụng Layout mặc định của CakePHP , dùng file CSS riêng
    var $name = "Users";
    var $helpers = array("Html","Common","Flash");
    var $component = array("Session");
    var $_sessionUsername  = "Username"; // tên Session được qui định trước
    var $content = "";



    //---------- View
    function view(){
        if(!$this->Session->read($this->_sessionUsername)) // đọc Session xem có tồn tại không
            $this->redirect("login");
        else {
            $link = '/users/game';
            if(isset($_POST['ok'])){
                $link = '/users/gametank';
            }
            $username = $this->Session->read('Username');
            $sql = "Select * from users Where name='$username'";
            $content = $this->User->query($sql);
            $content = $content[0];
            $this->set("content", $content);
            $this->render($link); // load 1 file view index.ctp trong thư mục “views/demos/users”/
        }

    }

    //--------- Login
    function login(){
        $error="";// thong bao loi
        if($this->Session->read($this->_sessionUsername))
            $this->redirect("view");

        if(isset($_POST['ok'])){
            $username = $_POST['username'];
            $password = $_POST['password'];
            if($this->check($username,$password)){
                $this->Session->write($this->_sessionUsername,$username);
                $this->redirect("view");
            }else{
                $error = "Tài khoản hoặc mật khẩu không hợp lệ";
            }
        }
        $this->set("error",$error);
        $this->render("/users/login");
    }

    function register(){
        $error="";// thong bao loi

        if (!empty($this->data)) {
            if(isset($_POST['ok'])){
                $username = $_POST['username'];
                $password = $_POST['password'];
                $comfirm_password = $_POST['confirm'];
                $email = $_POST['email'];
                $hoten = $_POST['hoten'];
                $sdt = $_POST['sdt'];
                $diachi = $_POST['diachi'];
                $ngaysinh = $_POST['ngaysinh'];
                $cmnd = $_POST['cmnd'];
                $sex = $_POST['nam'];
                if($this->check($username,$password)) {
                    $error = "Tài khoản hoặc mật khẩu không đã được sử dụng";
                } else if( $comfirm_password != $password) {
                    $error = "Mật khẩu xác nhận không chính xác";

                }else if($this->check($username,$password) == false && $comfirm_password == $password){
                    if($sex == "Nam") {
                        $sex = 1;
                    } else $sex = 0;
                    $this->User->create();
                    $this->User->set(array('name'=>$username,
                        'pass'=>$password,
                        'policy'=>1,
                        'real_name'=>$hoten,
                        'phone_num'=>$sdt,
                        'cmnd'=>$cmnd,
                        'birthday'=>$ngaysinh,
                        'sex'=>$sex,
                        'address'=>$diachi,
                        'email'=>$email));
                    $this->User->save();
                    $error = "Xin chúc mừng bạn đã đăng kí thành công!!!";
                }
            }

        }
        $this->set("error",$error);
        $this->render("/users/register");
    }

    function check($username,$password){
        $sql = "Select name, pass from users Where name='$username' AND pass ='$password'";
        $this->User->query($sql);
        if($this->User->getNumRows()==0){
            return false;
        }else{
            return true;
        }
    }
    //---------- Logout
    function logout(){
        $this->Session->delete($this->_sessionUsername);
        $this->redirect("login");
    }
}

