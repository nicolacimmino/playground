<?php
/**
 * Created by PhpStorm.
 * User: nicola
 * Date: 28/03/2015
 * Time: 15:12
 */

use \Illuminate\Database\Seeder;
use App\User;

class UsersTableSeeder extends Seeder  {

    public function run() {
        DB::table('users')->delete();
        User::create([
            'name' => 'nicola',
            'email' => 'nicola@bla.com',
            'password' => '$2y$10$F6GxKvJ5Q.2qMAtVPucSReX5yrVuKkJIBZlqE7fwl/ZhgH3GmXivC' // blabla
        ]);
    }
}