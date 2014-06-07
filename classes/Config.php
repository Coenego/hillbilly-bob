<?php

class Config {

    function __construct() {

        $this->live = false;

        if ($this->live) {
            $this->db = array (
                'host'=>'',
                'port'=>'',
                'database'=>'',
                'username'=>'',
                'password'=>''
            );
        } else {
            $this->db = array (
                'host'=>'localhost',
                'port'=>'',
                'database'=>'',
                'username'=>'',
                'password'=>''
            );
        }
    }
}

?>
