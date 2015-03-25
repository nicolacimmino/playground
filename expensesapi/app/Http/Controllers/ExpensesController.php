<?php
/**
 * Created by PhpStorm.
 * User: nicola
 * Date: 21/03/2015
 * Time: 12:15
 */

namespace App\Http\Controllers;



use App\Expense;
use App\ExpenseTransformer;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Input;

class ExpensesController extends ApiController
{
    public function index()
    {
        return ExpenseTransformer::transformCollection(Expense::all());
    }

    public function show($id)
    {
        $expense = Expense::find($id);
        if(!$expense)
        {
            return $this->respondWithNotFound();

        }
        return ExpenseTransformer::transform($expense);
    }

    public function store()
    {
        if(!Input::get('from') || !Input::get('to') || !Input::get('amount'))
        {
            return $this->respondWithBadRequest();
        }
        Expense::create([
            'source' => Input::get('from'),
            'destination' => Input::get('to'),
            'amount' => Input::get('amount')
                        ]);
        return $this->respondWithCreated();
    }

}