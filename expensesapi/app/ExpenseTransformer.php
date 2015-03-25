<?php
/**
 * Created by PhpStorm.
 * User: nicola
 * Date: 21/03/2015
 * Time: 12:46
 */

namespace App;


class ExpenseTransformer {

    public static function transformCollection($expenses)
    {
        return array_map(function($expense) {
            return ExpenseTransformer::transform($expense);
        }, $expenses->toArray());
    }

    public static function transform($expense)
    {
        return [
            'id' => $expense['id'],
            'from' => $expense['source'],
            'to' => $expense['destination'],
            'amount' => (float)$expense['amount'],
        ];
    }
}