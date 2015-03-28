<?php namespace App;

use Illuminate\Database\Eloquent\Model;

class Expense extends Model {

	protected $hidden = ['created_at', 'updated_at'];

    protected $fillable = ['source', 'destination', 'amount', 'user_id'];

    public function tags() {
        return $this->belongsToMany('App\Tag');
    }

    public function user() {
        return $this->belongsTo('App\User');
    }

}
