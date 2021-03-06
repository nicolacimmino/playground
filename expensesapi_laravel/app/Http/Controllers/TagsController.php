<?php
/**
 * Created by PhpStorm.
 * User: nicola
 * Date: 21/03/2015
 * Time: 15:23
 */

namespace App\Http\Controllers;
use App\Expense;
use App\ExpenseTransformer;
use App\Tag;
use App\TagTransformer;

class TagsController  extends ApiController {

    public function index() {
        return TagTransformer::transformCollection(Tag::all());
    }

    public function show($id) {
        return TagTransformer::transform(Tag::find($id));
    }

    public function expenses($id) {
        return ExpenseTransformer::transformCollection(Tag::find($id)->expenses()->get());
    }
}