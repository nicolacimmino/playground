<?php namespace App;

use Illuminate\Database\Eloquent\Model;

class Tag extends Model {

    //protected $hidden = ['id'];

    protected $fillable = ['name'];

    public function expenses()
    {
        return $this->belongsToMany('App\Expense');
    }
}
