<?php

class Users {

    public static function putUserIntoDatabase($email, $first_name, $last_name) {
        if ($email != null && $first_name != null && $first_name != null){
            global $dbh;
            try {
                $sql = "INSERT INTO dys_users (email, first_name, last_name) VALUES (:email, :first_name, :last_name)";
                $stmt = $dbh->prepare($sql);
                $stmt->bindParam(':email', $email);
                $stmt->bindParam(':first_name', $first_name);
                $stmt->bindParam(':last_name', $last_name);
                $stmt->execute();
                $result['success'] = true;
            } catch(Exception $e) {
                $result['success'] = false;
                $result['error'] = 'Error while connecting';
            }
        } else {
            $result['success'] = false;
            $result['error'] = 'Invalid entry';
        }
        return $result;
    }

    public static function checkIfUserAlreadyExists($email) {
        if ($email != null) {
            global $dbh;
            $sql = "SELECT email FROM dys_users WHERE email = :email";
            $stmt = $dbh->prepare($sql);
            $stmt->bindParam(':email', $email);
            $stmt->execute();
            $result['success'] = ($stmt->fetch(PDO::FETCH_OBJ)) ? true : false;
        } else {
            $result['success'] = false;
            $result['error'] = 'Invalid entry';
        }
        return $result;
    }

    public static function getUserDataFromDatabase($email) {
        if ($email != null) {
            global $dbh;
            try {
                $sql = "SELECT * FROM dys_users WHERE email = :email";
                $stmt = $dbh->prepare($sql);
                $stmt->bindParam(':email', $email);
                $stmt->execute();
                $user = $stmt->fetch(PDO::FETCH_OBJ);
                if ($user != null) {
                    $result['data'] = $user;
                    $result['success'] = true;
                } else {
                    $result['success'] = false;
                    $result['error'] = 'User doesn\'t exist';
                }
            } catch(Exception $e) {
                $result['success'] = false;
                $result['error'] = 'Error while connecting';
            }
        } else {
            $result['success'] = false;
            $result['error'] = 'Invalid entry';
        }
        return $result;
    }

    public static function saveScoreToDatabase($email, $vehicle, $score) {
        if ($email != null && $score != null && $vehicle != null) {
            global $dbh;
            try {
                $sql = "UPDATE dys_users SET score = :score, vehicle = :vehicle WHERE email = :email";
                $stmt = $dbh->prepare($sql);
                $stmt->bindParam(':email', $email);
                $stmt->bindParam(':vehicle', $vehicle);
                $stmt->bindParam(':score', $score);
                $stmt->execute();
                $result['success'] = true;
            } catch (Exception $e) {
                $result['success'] = false;
                $result['error'] = 'Error while saving score and vehicle';
            }
        } else {
            $result['success'] = false;
            $result['error'] = 'Invalid entry';
        }
        return $result;
    }
}

?>
