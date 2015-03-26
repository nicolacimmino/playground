<?php

use Illuminate\Database\Seeder;
use App\Expense;

class ExpensesTableSeeder extends Seeder {
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('expenses')->delete();

        $sources = ['bank', 'cash'];
        $destinations = ['food', 'car', 'travel'];

        for($ix=0;$ix<100;$ix++) {
            Expense::create(
                ['source' => $sources[rand(0, count($sources) - 1)],
                'destination' => $destinations[rand(0, count($destinations) - 1)],
                'amount' => rand(1,100),
            ]);

        }
    }

}
