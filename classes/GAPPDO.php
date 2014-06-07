<?php

class GAPPDO extends PDO {

    private static $instance;

    public static function getInstance() {

        global $config;

        if (is_null(self::$instance)) {
            self::$instance = new PDO('mysql:host=' . $config->db['host'] . ';port=' . $config->db['port'] . ';dbname=' . $config->db['database'], $config->db['username'], $config->db['password']);
            self::$instance->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        }

        return self::$instance;
    }
}

?>
