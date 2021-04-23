<?php
// used to connect to the database
$DB_HOST = "localhost";
$db_name = "icecreamdb";
$table = "Product";
$username = "root";
$password = "testuser";

$action = $_POST["action"];
 
//connect to database
try {
    $con = new PDO("mysql:host={$DB_HOST};dbname={$db_name}", $username, $password);
}
catch(PDOException $exception){
    echo "Connection error: " . $exception->getMessage();
}

//action to get all records
if("GET_ALL" == $action){
    $db_data = array();
    $sql = "SELECT product_name, brand_name, subhead, description, avg_rating, num_ratings
            FROM $table ORDER BY product_id";
    $result = $con->query($sql);

    if($result->num_rows > 0){
        while($row = $result->fetchAll()){
            $db_data[] = $row;
        }
        echo json_encode($db_data);
    } else{
        echo "Error";
    }

    $con->close();
    return;
}

#action to add a product
if("ADD" == $action){
    $product_id = $_POST["product_id"];
    $product_name = $_POST["product_name"];
    $brand_name = $_POST["brand_name"];
    $subhead = $_POST["subhead"];
    $description = $_POST["description"];
    $avg_rating = $_POST["avg_rating"];
    $num_ratings = $_POST["num_ratings"];

    $sql = "INSERT INTO $table 
            VALUES($product_id, $product_name, $brand_name, $subhead, $description, $avg_rating, $num_ratings)";

    $result = $con->query($sql);
    echo "Added!";
    $con->close();
    return;    
}

//action to update a product
if("UPDATE" == "$action"){
    $product_id = $_POST["product_id"];
    $product_name = $_POST["product_name"];
    $brand_name = $_POST["brand_name"];
    $subhead = $_POST["subhead"];
    $description = $_POST["description"];
    $avg_rating = $_POST["avg_rating"];
    $num_ratings = $_POST["num_ratings"];

    $sql = "UPDATE $table SET product_id=$product_id, product_name=$product_name, brand_name=$brand_name, subhead=$subhead, 
           description=$description, avg_rating=$avg_rating, num_ratings=$num_ratings";

    if($con->query(sql) === TRUE){
        echo "Updated!";
    } else{
        echo "Error";
    }

    $con->close();
    return;
}

//action to delete a product
if("DELETE" == "$action"){
    $product_id = $_POST["product_id"];
    $sql = "DELETE FROM $table WHERE product_id = $product_id"; 

    if($con->query(sql) === TRUE){
        echo "Deleted!";
    } else{
        echo "Error";
    }

    $con->close();
    return;
}
?>