<?php
$connect = new mysqli("localhost","root","","app_news");

if ($connect) {
    // echo "Success";
}else {
    echo "failed";
    exit();
}
?>