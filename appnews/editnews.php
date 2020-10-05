<?php 
include "connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array();
    $title = $_POST['title'];
    $content = $_POST['content'];
    $description = $_POST['description'];
    $id_news = $_POST['id_news'];

    $image = date('dmYHis').str_replace(" ","", basename($_FILES['image']['name']));
    $imagePath = "upload/".$image;
    move_uploaded_file($_FILES['image']['tmp_name'], $imagePath);

    
        $edit = "UPDATE tb_news SET image='$image', title='$title', content='$content', description='$description' WHERE id_news='$id_news'";
            if (mysqli_query($connect,$edit)) {
                $response['value'] = 1;
                $response['message'] = "Edit News Success";
                echo json_encode($response);
            }else {
                $response['value'] = 0;
                $response['message'] = "Edit News Failed";
                echo json_encode($response);
            }
}
?>