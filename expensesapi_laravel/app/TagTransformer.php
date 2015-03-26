<?php

namespace App;


class TagTransformer {

    public static function transformCollection($tags)
    {
        return array_map(function($tag) {
            return TagTransformer::transform($tag);
        }, $tags->toArray());
    }

    public static function transform($tag)
    {
        return [
            'name' => $tag['name']
        ];
    }
}