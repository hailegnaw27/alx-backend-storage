#!/usr/bin/env python3
'''
A module with tools for request caching and tracking.
'''
import redis
import requests
from functools import wraps
from typing import Callable

# Module-level Redis instance
redis_store = redis.Redis()

def data_cacher(method: Callable) -> Callable:
    '''
    Decorator to cache the output of fetched data.
    '''
    @wraps(method)
    def invoker(url) -> str:
        '''
        Wrapper function for caching the output.
        '''
        # Increment access count for the URL
        redis_store.incr(f'count:{url}')
        # Check if result is cached
        result = redis_store.get(f'result:{url}')
        if result:
            return result.decode('utf-8')
        # If not cached, fetch new content and update cache
        result = method(url)
        # Reset access count and set result with expiration time of 10 seconds
        redis_store.set(f'count:{url}', 0)
        redis_store.setex(f'result:{url}', 10, result)
        return result
    return invoker

@data_cacher
def get_page(url: str) -> str:
    '''
    Returns the content of a URL after caching the request's response,
    and tracking the request.
    '''
    return requests.get(url).text

