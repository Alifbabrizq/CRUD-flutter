<?php 
include "connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array();
    $email = $_POST['email'];
    $password = md5($_POST['password']);

    $check = "SELECT * FROM tb_user WHERE email='$email' and password='$password'";
    $result = mysqli_fetch_array(mysqli_query($connect,$check));

    if (isset($result)) {
        $response['value'] = 1;
        $response['message'] = "Login Success";
        $response['username'] = $result['username'];
        $response['email'] = $result['email'];
        $response['id_user'] = $result['id_user'];
        echo json_encode($response);
    }else {
        $response ['value'] = 0;
        $response['message'] = "Login Failed";
        echo json_encode($response);
    } 
}
?>