#!/usr/bin/env python3
"""
Module for Redis interactions
"""

import redis
from uuid import uuid4
from typing import Union, Callable, Optional
from functools import wraps

def count_calls(method: Callable) -> Callable:
    """Decorator to count the number of times a method is called"""
    key = method.__qualname__

    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """Wrapper function to increment the count of method calls"""
        self._redis.incr(key)
        return method(self, *args, **kwargs)

    return wrapper

def call_history(method: Callable) -> Callable:
    """Decorator to store the history of method calls"""
    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """Wrapper function to store input and output of method calls"""
        input_str = str(args)
        self._redis.rpush(method.__qualname__ + ":inputs", input_str)
        output_str = str(method(self, *args, **kwargs))
        self._redis.rpush(method.__qualname__ + ":outputs", output_str)
        return output_str

    return wrapper

def replay(fn: Callable):
    """Function to replay the history of method calls"""
    r = redis.Redis()
    function_name = fn.__qualname__
    value = r.get(function_name)
    try:
        value = int(value.decode("utf-8"))
    except Exception:
        value = 0

    print("{} was called {} times:".format(function_name, value))
    inputs = r.lrange("{}:inputs".format(function_name), 0, -1)
    outputs = r.lrange("{}:outputs".format(function_name), 0, -1)

    for input_data, output_data in zip(inputs, outputs):
        try:
            input_data = input_data.decode("utf-8")
        except Exception:
            input_data = ""

        try:
            output_data = output_data.decode("utf-8")
        except Exception:
            output_data = ""

        print("{}(*{}) -> {}".format(function_name, input_data, output_data))

class Cache:
    """Class for caching data in Redis"""

    def __init__(self):
        """Initialize Redis client instance"""
        self._redis = redis.Redis()
        self._redis.flushdb()

    @count_calls
    @call_history
    def store(self, data: Union[str, bytes, int, float]) -> str:
        """Method to store data in Redis and return the generated key"""
        random_key = str(uuid4())
        self._redis.set(random_key, data)
        return random_key

    def get(self, key: str,
            fn: Optional[Callable] = None) -> Union[str, bytes, int, float]:
        """Method to retrieve data from Redis and optionally convert it"""
        value = self._redis.get(key)
        if fn:
            value = fn(value)
        return value

    def get_str(self, key: str) -> str:
        """Method to retrieve string data from Redis"""
        value = self._redis.get(key)
        return value.decode("utf-8")

    def get_int(self, key: str) -> int:
        """Method to retrieve integer data from Redis"""
        value = self._redis.get(key)
        try:
            value = int(value.decode("utf-8"))
        except Exception:
            value = 0
        return value

