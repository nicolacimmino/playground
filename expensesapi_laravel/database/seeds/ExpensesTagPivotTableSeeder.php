<?php

use Illuminate\Database\Seeder;
use App\Tag;
use App\Expense;

class ExpensesTagPivotTableSeeder extends Seeder {

    public function run()
    {

        $expensesIds = Expense::lists('id');
        $tagsIds = Tag::lists('id');

        DB::table('expense_tag')->delete();
        for($ix=0;$ix<10;$ix++)
        {
            DB::table('expense_tag')->insert([
                'expense_id' => $expensesIds[rand(0, count($expensesIds) - 1)],
                'tag_id' => $tagsIds[rand(0, count($tagsIds) - 1)]
            ]);
        }
    }
}