<?php 
include "connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array();
    $title = $_POST['title'];
    $content = $_POST['content'];
    $description = $_POST['description'];
    $id_user = $_POST['id_user'];
    $image = date('dmYHis').str_replace(" ","", basename($_FILES['image']['name']));
    $imagePath = "upload/".$image;
    move_uploaded_file($_FILES['image']['tmp_name'], $imagePath);

    
        $insert = "INSERT INTO tb_news VALUE(NULL, '$image', '$title', '$content', '$description',NOW(), '$id_user')";
            if (mysqli_query($connect,$insert)) {
                $response['value'] = 1;
                $response['message'] = "Add News Success";
                echo json_encode($response);
            }else {
                $response['value'] = 0;
                $response['message'] = "Add News Failed";
                echo json_encode($response);
            }
}
?>