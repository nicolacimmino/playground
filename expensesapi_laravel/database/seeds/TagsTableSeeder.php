<?php

use Illuminate\Database\Seeder;
use App\Tag;

class TagsTableSeeder extends Seeder {

    public function run()
    {
        DB::table('tags')->delete();
        Tag::create(['name' => 'summer trip']);
        Tag::create(['name' => 'visit london']);
        Tag::create(['name' => 'everyday']);
        Tag::create(['name' => 'refundable']);

    }
}