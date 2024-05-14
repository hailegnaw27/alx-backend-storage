#!/usr/bin/env python3
"""
This module provides a script to analyze nginx logs.
"""

from pymongo import MongoClient


def log_stats(mongo_collection):
    """
    Analyze nginx logs and print statistics.

    Args:
        mongo_collection: pymongo collection object.
    """
    total_logs = mongo_collection.count_documents({})
    print("{} logs".format(total_logs))

    # Count methods
    methods = mongo_collection.aggregate([
        {"$group": {"_id": "$method", "count": {"$sum": 1}}}
    ])
    print("Methods:")
    for method in methods:
        print("    method {}: {}".format(method["_id"], method["count"]))

    # Count status check
    status_check = mongo_collection.count_documents({"method": "GET", "path": "/status"})
    print("{} status check".format(status_check))

    # Count IPs
    top_ips = mongo_collection.aggregate([
        {"$group": {"_id": "$ip", "count": {"$sum": 1}}},
        {"$sort": {"count": -1}},
        {"$limit": 10}
    ])
    print("IPs:")
    for ip in top_ips:
        print("    {}: {}".format(ip["_id"], ip["count"]))


if __name__ == "__main__":
    # Example usage
    client = MongoClient('mongodb://127.0.0.1:27017')
    logs_collection = client.logs.nginx

    log_stats(logs_collection)

