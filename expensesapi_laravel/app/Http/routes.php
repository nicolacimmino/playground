<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

Route::get('/', 'WelcomeController@index');

Route::group(['prefix' => 'api/v1', 'middleware' => 'auth.basic'], function()
{
    Route::resource('expenses', 'ExpensesController');
    Route::get('expenses/{id}/tags', 'ExpensesController@tags');
    Route::resource('tags', 'TagsController', ['only' => ['index', 'show']]);
    Route::get('tags/{id}/expenses', 'TagsController@expenses');

});

Route::controllers([
    'auth' => 'Auth\AuthController',
    'password' => 'Auth\PasswordController',
]);
