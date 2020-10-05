<?php 
include "connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array();
    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = md5($_POST['password']);

    $check = "SELECT * FROM tb_user WHERE email='$email'";
    $result = mysqli_fetch_array(mysqli_query($connect,$check));

    if (isset($result)) {
        $response ['value'] = 2;
        $response['message'] = "Email already in use";
        echo json_encode($response);
    }else {
        $insert = "INSERT INTO tb_user VALUE(NULL, '$username', '$email', '$password', '1',NOW())";
            if (mysqli_query($connect,$insert)) {
                $response['value'] = 1;
                $response['message'] = "Register Success";
                echo json_encode($response);
            }else {
                $response['value'] = 0;
                $response['message'] = "Register Failed";
                echo json_encode($response);
            }
    } 
}
?>