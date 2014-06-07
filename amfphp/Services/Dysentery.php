<?php

require_once('../classes/Config.php');
require_once('../classes/GAPPDO.php');
require_once('../classes/DAO/Users.php');
require_once('../classes/DAO/Game.php');

global $dbh;
global $config;

$config = new Config();
$dbh = GAPPDO::getInstance();

class Dysentery
{
    // Users
    function putUserIntoDatabase($data){
        return Users::putUserIntoDatabase($data->email, $data->first_name, $data->last_name);
    }

    function checkIfUserAlreadyExists($data){
        return Users::checkIfUserAlreadyExists($data->email);
    }

    function getUserDataFromDatabase($data){
        return Users::getUserDataFromDatabase($data->email);
    }

    function saveScoreToDatabase($data){
        return Users::saveScoreToDatabase($data->email, $data->vehicle, $data->score);
    }

    // Game
    function getHighScores($data){
        return Game::getHighScores($data->limit);
    }
}

?>