<?php
class UsersController extends AppController {
    var $layout = false; // Không sử dụng Layout mặc định của CakePHP , dùng file CSS riêng
    var $name = "Users";
    var $helpers = array("Html","Common","Flash");
    var $component = array("Session");
    var $_sessionUsername  = "Username"; // tên Session được qui định trước
    var $_sessionPolicy  = "Policy";
    var $content = "";



    //---------- View
    function view(){
        if(!$this->Session->read($this->_sessionUsername)) // đọc Session xem có tồn tại không
            $this->redirect("login");
        else {
            if(isset($_POST['ok'])){
                $this->render('/users/gametank');
            }
            $username = $this->Session->read('Username');
            $sql = "Select * from users Where name='$username'";
            $content = $this->User->query($sql);
            $content = $content[0];
            $this->Session->write($this->_sessionPolicy,$content['users']['policy']);
            $this->set("content", $content);

            if($content['users']['policy'] == 1) {
                $this->set("policy", "Thành viên");
                $this->render('/users/userlogin');
            }
            if($content['users']['policy'] == 2) {
                $this->set("policy", "GM");
                $this->render('/users/gmlogin');
            }
            if($content['users']['policy'] >= 3) {
                $this->set("policy", "Manager");
                $this->render('/users/managerlogin');
            }
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
    function editlogin(){
        $error="";// thong bao loi
        $username = $this->Session->read('Username');
        $sql = "Select * from users Where name='$username'";
        $content = $this->User->query($sql);
        $content = $content[0];
        if (!empty($this->data)) {
            if(isset($_POST['ok'])){
                $username = $content['users']['name'];
                $password = $content['users']['pass'];
                $email = $_POST['email'];
                $hoten = $_POST['hoten'];
                $sdt = $_POST['sdt'];
                $diachi = $_POST['diachi'];
                $ngaysinh = $_POST['ngaysinh'];
                $cmnd = $_POST['cmnd'];
                $sex = $_POST['nam'];
                if($this->check($username,$password) == true){
                    if($sex == "Nam") {
                        $sex = 1;
                    } else if($sex == "Nu") {
                        $sex = 2;
                    }
                    $this->User->id = $content['users']['id'];
                    if ($hoten != null) {
                        $this->User->saveField('real_name',$hoten);
                    }
                    if ($sdt != null) {
                        $this->User->saveField('phone_num',$sdt);
                    }
                    if ($cmnd != null) {
                        $this->User->saveField('cmnd',$cmnd);
                    }
                    if ($ngaysinh != null) {
                        $this->User->saveField('birthday',$ngaysinh);
                    }
                    if ($sex != null) {
                        $this->User->saveField('sex',$sex);
                    }
                    if ($email != null) {
                        $this->User->saveField('email',$email);
                    }
                    if ($diachi != null) {
                        $this->User->saveField('address',$diachi);
                    }
                    $error = "Xin chúc mừng bạn đã sửa đổi thành công!!!";
                }
            }

        }
        $this->set("error",$error);
        if($content['users']['policy'] == 1) {
            $this->set("policy", "Thành viên");
            $this->render("/users/userloginedit");
        }
        if($content['users']['policy'] == 2) {
            $this->set("policy", "GM");
            $this->render('/users/gmeditlogin');
        }
        if($content['users']['policy'] == 3) {
            $this->set("policy", "Manager");
            $this->render('/users/gmeditlogin');
        }
    }
    function edituser($name){
        $error="";// thong bao loi
        $username = $name;
        $sql = "Select * from users Where name='$username'";
        $content = $this->User->query($sql);
        $content = $content[0];
        if (!empty($this->data)) {
            if(isset($_POST['ok'])){
                $username = $content['users']['name'];
                $password = $content['users']['pass'];
                $email = $_POST['email'];
                $hoten = $_POST['hoten'];
                $sdt = $_POST['sdt'];
                $diachi = $_POST['diachi'];
                $ngaysinh = $_POST['ngaysinh'];
                $cmnd = $_POST['cmnd'];
                $sex = $_POST['nam'];
                if($this->check($username,$password) == true){
                    if($sex == "Nam") {
                        $sex = 1;
                    } else if($sex == "Nu") {
                        $sex = 2;
                    }
                    $this->User->id = $content['users']['id'];
                    if ($hoten != null) {
                        $this->User->saveField('real_name',$hoten);
                    }
                    if ($sdt != null) {
                        $this->User->saveField('phone_num',$sdt);
                    }
                    if ($cmnd != null) {
                        $this->User->saveField('cmnd',$cmnd);
                    }
                    if ($ngaysinh != null) {
                        $this->User->saveField('birthday',$ngaysinh);
                    }
                    if ($sex != null) {
                        $this->User->saveField('sex',$sex);
                    }
                    if ($email != null) {
                        $this->User->saveField('email',$email);
                    }
                    if ($diachi != null) {
                        $this->User->saveField('address',$diachi);
                    }
                    $error = "Xin chúc mừng bạn đã sửa đổi thành công!!!";
                }
            }

        }
        $this->set("error",$error);
        $myname = $this->Session->read('Username');
        $sql1 = "Select * from users Where name='$myname'";
        $contentTempt = $this->User->query($sql1);
        $contentTempt = $contentTempt[0];
        if($contentTempt['users']['policy'] == 1) {
            $this->set("policy", "Thành viên");
        }
        if($contentTempt['users']['policy'] == 2) {
            $this->set("policy", "GM");
        }
        if($contentTempt['users']['policy'] == 3) {
            $this->set("policy", "Manager");
        }
        $this->render('/users/gmeditlogin');
    }

    function manageusers() {
        $error="";// thong bao loi
        $username = $this->Session->read('Username');
        $sql = "Select * from users Where name='$username'";
        $content = $this->User->query($sql);
        $content = $content[0];
        $this->set("content", $content);
        //data
        $sql = "Select * from users Where policy = 1";
        $data = $this->User->query($sql);
        $this->set("data", $data);
        if($data == null) {
            $error="Không có thành viên nào";
        }
        if($content['users']['policy'] == 1) {
            $this->set("policy", "Thành viên");
        }
        if($content['users']['policy'] == 2) {
            $this->set("policy", "GM");
        }
        if($content['users']['policy'] == 3) {
            $this->set("policy", "Manager");
        }
        $this->set("error",$error);
        $this->render("/users/manageusers");
    }

    function manageusersandgm() {
        $error="";// thong bao loi
        $username = $this->Session->read('Username');
        $sql = "Select * from users Where name='$username'";
        $content = $this->User->query($sql);
        $content = $content[0];
        $this->set("content", $content);
        $this->Session->write($this->_sessionPolicy,$content['users']['policy']);
        //data
        $sql = "Select * from users Where policy < 3";
        $data = $this->User->query($sql);
        $this->set("data", $data);
        if($data == null) {
            $error="Không có thành viên nào";
        }
        if($content['users']['policy'] == 1) {
            $this->set("policy", "Thành viên");
        }
        if($content['users']['policy'] == 2) {
            $this->set("policy", "GM");
        }
        if($content['users']['policy'] == 3) {
            $this->set("policy", "Manager");
        }
        $this->set("error",$error);
        $this->render("/users/manageusersandgm");
    }

    function edituserandgm($name){
        $error="";// thong bao loi
        $username = $name;
        $sql = "Select * from users Where name='$username'";
        $content = $this->User->query($sql);
        $content = $content[0];
        if (!empty($this->data)) {
            if(isset($_POST['ok'])){
                $username = $content['users']['name'];
                $password = $content['users']['pass'];
                $email = $_POST['email'];
                $hoten = $_POST['hoten'];
                $sdt = $_POST['sdt'];
                $diachi = $_POST['diachi'];
                $ngaysinh = $_POST['ngaysinh'];
                $cmnd = $_POST['cmnd'];
                $sex = $_POST['nam'];
                $policy = $_POST['policy'];
                if($this->check($username,$password) == true){
                    if($sex == "Nam") {
                        $sex = 1;
                    } else if($sex == "Nu") {
                        $sex = 2;
                    }
                    if($policy == "Thành viên") {
                        $policy = 1;
                    } else if($policy == "GM") {
                        $policy = 2;
                    }
                    $this->User->id = $content['users']['id'];
                    if ($policy != null) {
                        $this->User->saveField('policy',$policy);
                    }
                    if ($hoten != null) {
                        $this->User->saveField('real_name',$hoten);
                    }
                    if ($sdt != null) {
                        $this->User->saveField('phone_num',$sdt);
                    }
                    if ($cmnd != null) {
                        $this->User->saveField('cmnd',$cmnd);
                    }
                    if ($ngaysinh != null) {
                        $this->User->saveField('birthday',$ngaysinh);
                    }
                    if ($sex != null) {
                        $this->User->saveField('sex',$sex);
                    }
                    if ($email != null) {
                        $this->User->saveField('email',$email);
                    }
                    if ($diachi != null) {
                        $this->User->saveField('address',$diachi);
                    }
                    $error = "Xin chúc mừng bạn đã sửa đổi thành công!!!";
                }
            }

        }
        $this->set("error",$error);
        $myname = $this->Session->read('Username');
        $sql1 = "Select * from users Where name='$myname'";
        $contentTempt = $this->User->query($sql1);
        $contentTempt = $contentTempt[0];
        if($contentTempt['users']['policy'] == 1) {
            $this->set("policy", "Thành viên");
        }
        if($contentTempt['users']['policy'] == 2) {
            $this->set("policy", "GM");
        }
        if($contentTempt['users']['policy'] == 3) {
            $this->set("policy", "Manager");
        }
        $this->render('/users/manageuserdandgmedit');
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

