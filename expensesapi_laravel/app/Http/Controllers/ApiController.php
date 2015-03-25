<?php
/**
 * Created by PhpStorm.
 * User: nicola
 * Date: 21/03/2015
 * Time: 13:06
 */
namespace App\Http\Controllers;



use App\Http\Controllers\Controller;
use Illuminate\Http\Response;

class ApiController extends Controller {

    private $error;

    public function setError($error)
    {
        $this->error = $error;
        return $this;
    }

    public function respondWithError()
    {
        return (new Response())->setStatusCode($this->error);
    }

    public function respondWithBadRequest()
    {
        return $this->setError(400)->respondWithError();
    }

    public function respondWithNotFound()
    {
        return $this->setError(404)->respondWithError();
    }

    public function respondWithCreated()
    {
        return $this->setError(201)->respondWithError();
    }

}