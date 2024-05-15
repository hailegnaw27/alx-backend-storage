#!/usr/bin/env python3
"""
Module for web caching and tracking
"""

import requests
import redis
import time
from functools import wraps

def cache_page(url: str, expiration: int = 10):
    """Decorator to cache web pages with expiration time"""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            key = f"cache:{url}"
            cached_page = redis_client.get(key)
            if cached_page:
                return cached_page.decode("utf-8")
            else:
                page_content = func(*args, **kwargs)
                redis_client.setex(key, expiration, page_content)
                return page_content
        return wrapper
    return decorator

def track_access(url: str):
    """Decorator to track the number of times a URL is accessed"""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            redis_client.incr(f"count:{url}")
            return func(*args, **kwargs)
        return wrapper
    return decorator

redis_client = redis.Redis()

@cache_page("http://slowwly.robertomurray.co.uk/delay/5000/url/https://www.example.com")
@track_access("http://slowwly.robertomurray.co.uk/delay/5000/url/https://www.example.com")
def get_page(url: str) -> str:
    """Function to retrieve the HTML content of a URL"""
    response = requests.get(url)
    return response.text

if __name__ == "__main__":
    url = "http://slowwly.robertomurray.co.uk/delay/5000/url/https://www.example.com"
    for _ in range(3):
        print(get_page(url))
        time.sleep(1)
    print(f"Access count for {url}: {redis_client.get(f'count:{url}')}")

