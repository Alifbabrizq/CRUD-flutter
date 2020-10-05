<?php 
include "connect.php";

    $response = array();

    $sql = mysqli_query($connect, "SELECT a.*, b.username FROM tb_news a LEFT JOIN tb_user b on a.id_user=b.id_user ORDER BY a.id_user DESC");

    while($a= mysqli_fetch_array($sql)){
        $b['id_news'] = $a['id_news'];
        $b['image'] = $a['image'];
        $b['title'] = $a['title'];
        $b['content'] = $a['content'];
        $b['description'] = $a['description'];
        $b['date_news'] = $a['date_news'];
        $b['id_user'] = $a['id_user'];
        $b['username'] = $a['username'];

        array_push($response, $b);
    }
    echo json_encode($response);
?>