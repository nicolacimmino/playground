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

/*
 * Base ApiController. All controllers serving API resources should
 * extend this. In this way we can provide consistent responses and
 * we encapsulate the generation of the responses in a single place.
 */
class ApiController extends Controller {

    private $status_code;

    private $content;

    /*
     * Sets the status code. This is private to force
     * the usage of the the "respond" methods.
     */
    private function setStatusCode($error)
    {
        $this->status_code = $error;
        return $this;
    }

    private function setContent($content) {
        $this->content = $content;
        return $this;
    }

    private function respondWithError()
    {
        // If the error is not explicitely set
        // give an internal server error.
        if(!$this->status_code) {
            $this->setStatusCode(500);
        }
        return (new Response())->setStatusCode($this->status_code);
    }


    private function respondWithSuccess()
    {
        // If the error is not explicitely set
        // give a default 200.
        if(!$this->status_code) {
            $this->setStatusCode(200);
        }
        return (new Response())->setStatusCode($this->status_code)->setContent($this->content);
    }

    public function respondWithBadRequest()
    {
        return $this->setStatusCode(400)->respondWithError();
    }

    public function respondWithNotFound()
    {
        return $this->setStatusCode(404)->respondWithError();
    }

    public function respondWithCreated($id)
    {
        return $this->setStatusCode(201)->setContent(['id'=>$id])->respondWithSuccess();
    }

}