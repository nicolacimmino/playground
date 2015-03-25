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
        Expense::create(['source' => 'bank',
                                'destination' => 'food',
                                'amount' => 12
        ]);

        Expense::create(['source' => 'bank',
            'destination' => 'car',
            'amount' => 20.2
        ]);

        Expense::create(['source' => 'cash',
            'destination' => 'food',
            'amount' => 2
        ]);

    }

}
