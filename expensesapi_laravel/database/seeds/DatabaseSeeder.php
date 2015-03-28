<?php

use Illuminate\Database\Seeder;
use Illuminate\Database\Eloquent\Model;

class DatabaseSeeder extends Seeder {

	/**
	 * Run the database seeds.
	 *
	 * @return void
	 */
	public function run()
	{
        // Disables mass assignable restrictions.
		Model::unguard();

        // According to laracasts videos this is needed to
        // avoid errors when truncating the tables (true). I used
        // delete though as it runs all the triggers and
        // takes care of all the foreign keys. The video
        // said "delete won't do what you expect". Need to find out!
        //DB::statement("SET FOREIGN_KEY_CHECKS=0");

        $this->call('UsersTableSeeder');
        $this->call('ExpensesTableSeeder');
        $this->call('TagsTableSeeder');
        $this->call('ExpensesTagPivotTableSeeder');

        //DB::statement("SET FOREIGN_KEY_CHECKS=1");
	}

}



