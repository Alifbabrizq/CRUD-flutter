<?php 
include "connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array();
    $id_news = $_POST['id_news'];
    
        $delete = "DELETE FROM tb_news WHERE id_news='$id_news'";
            if (mysqli_query($connect,$delete)) {
                $response['value'] = 1;
                $response['message'] = "Hapus News Success";
                echo json_encode($response);
            }else {
                $response['value'] = 0;
                $response['message'] = "Hapus News Failed";
                echo json_encode($response);
            }
}
?>