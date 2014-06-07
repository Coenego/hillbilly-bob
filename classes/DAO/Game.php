<?php

class Game {

    public static function getHighScores($limit) {
        if ($limit != null) {
            global $dbh;
            $sql = "SELECT * FROM dys_users ORDER BY score DESC LIMIT :limit";
            $stmt = $dbh->prepare($sql);
            $stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
            $stmt->execute();
            while($user = $stmt->fetch(PDO::FETCH_OBJ)){
                $result['users'][] = $user;
            }
            $result['success'] = true;
        } else {
            $result['success'] = false;
            $result['error'] = 'Invalid entry';
        }
        return $result;
    }
}

?>
