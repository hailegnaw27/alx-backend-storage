#!/usr/bin/env python3
"""
nosql code
"""


import pymongo


def insert_school(mongo_collection, **kwargs):
    """insert school"""
    return mongo_collection.insert(kwargs)

