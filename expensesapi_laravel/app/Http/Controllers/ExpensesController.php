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
use App\TagTransformer;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Input;

class ExpensesController extends ApiController
{
    public function index()
    {
        $page = Input::get('page',1);
        $limit = 10;
        $expenses = Expense::all()->forPage($page, $limit);
        return ExpenseTransformer::transformCollection($expenses);
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

    public function expenseTags($id)
    {
        $expense = Expense::find($id);
        if(!$expense)
        {
            return $this->respondWithNotFound();

        }
        return TagTransformer::transformCollection(Expense::find($id)->tags);

        // Or this to just return a list of names
        //return Expense::find($id)->tags->lists('name');
    }

}