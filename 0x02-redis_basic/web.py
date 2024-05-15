#!/usr/bin/env python3
"""
Module for web caching and tracking
"""

import redis
import requests
from functools import wraps

# Redis connection
redis_client = redis.Redis()

def url_access_count(method):
    """Decorator to track URL access count and cache web pages"""
    @wraps(method)
    def wrapper(url):
        """Wrapper function to track URL access count and cache web pages"""
        # Generate cache key
        key = "cached:" + url
        # Check if the page is cached
        cached_value = redis_client.get(key)
        if cached_value:
            # If cached, return the cached page content
            return cached_value.decode("utf-8")

        # If not cached, fetch new content and update cache
        key_count = "count:" + url
        html_content = method(url)

        # Increment URL access count
        redis_client.incr(key_count)
        # Set cache with expiration time of 10 seconds
        redis_client.set(key, html_content, ex=10)
        redis_client.expire(key, 10)

        return html_content
    return wrapper

@url_access_count
def get_page(url: str) -> str:
    """Function to retrieve the HTML content of a URL"""
    results = requests.get(url)
    return results.text

if __name__ == "__main__":
    get_page('http://slowwly.robertomurray.co.uk')

