import requests
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor, as_completed
import sqlite3
import json
from urllib.parse import quote
import os
print("Pyautomation0(api data) imported. __name__ =", __name__)

def scrapelotus():
    print("scraper1 function actually running")
    offset=0
    BASE_DIR = os.path.dirname(__file__)  # folder where ProductSearcher.py lives
    DB_PATH = os.path.join(BASE_DIR, "products.db")
    connect=sqlite3.connect(DB_PATH)     #connection to database file
    c = connect.cursor()        #cursor is like a tool in sqlite to perform action through python
    c.execute("""
    CREATE TABLE IF NOT EXISTS lotusproducts (
        sku TEXT PRIMARY KEY,
        name TEXT,
        link TEXT,
        final_price TEXT,
        normal_price TEXT,
        stock TEXT
    )
    """)
    # c.execute("ALTER TABLE products ADD COLUMN stock TEXT")
    connect.commit()            #save action
    def scrapepagegrocery(offset):
        print("scraper1 function actually running")       
        data = {}

        while True:
            payload = {
            "offset": offset,
            "limit": 15,
            "filter": {"categoryId": ["2730"]},
            "websiteCode": "malaysia_hy"}

            url = (
            "https://api-o2o.lotuss.com.my/lotuss-mobile-bff/product/v2/products"
            + "?q=" + quote(json.dumps(payload)))
        
            resp = requests.get(url, headers={"User-Agent": "Mozilla/5.0","accept-language": "en",})
            data = resp.json()
            a=data["data"]["products"]
            for x in a:
                print(x["name"])
                link=x["mediaGallery"]
                for obj in link:
                    finalurl=obj["url"]
                try:                                                                            #sqlite 
                    c.execute("INSERT OR REPLACE INTO lotusproducts VALUES (?,?,?,?,?,?)",       #if exists, then replace the data with most recent fetched data
                                (x['sku'], x['name'], finalurl, x["priceRange"]["minimumPrice"]['finalPrice']["value"], x["priceRange"]["minimumPrice"]["regularPrice"]["value"],x["stockStatus"]))
                    connect.commit()

                except sqlite3.IntegrityError:
                            # SKU exists → you can optionally update prices
                    pass
            offset+=15
            if offset>=int(data["meta"]["total"]):
                break

    def scrapepagebeverage(offset):
        print("scraper1 function actually running")       
        data = {}
        while True:
            payload = {
            "offset": offset,
            "limit": 15,
            "filter": {"categoryId": ["9405"]},
            "websiteCode": "malaysia_hy"}

            url = (
            "https://api-o2o.lotuss.com.my/lotuss-mobile-bff/product/v2/products"
            + "?q=" + quote(json.dumps(payload)))
        
            resp = requests.get(url, headers={"User-Agent": "Mozilla/5.0","accept-language": "en",})
            data = resp.json()
            a=data["data"]["products"]
            for x in a:
                print(x["name"])
                link=x["mediaGallery"]
                for obj in link:
                    finalurl=obj["url"]
                try:                                                                            #sqlite 
                    c.execute("INSERT OR REPLACE INTO lotusproducts VALUES (?,?,?,?,?,?)",       #if exists, then replace the data with most recent fetched data
                                (x['sku'], x['name'], finalurl, x["priceRange"]["minimumPrice"]['finalPrice']["value"], x["priceRange"]["minimumPrice"]["regularPrice"]["value"],x["stockStatus"]))
                    connect.commit()

                except sqlite3.IntegrityError:
                            # SKU exists → you can optionally update prices
                    pass
            offset+=15
            if offset>=int(data["meta"]["total"]):
                break
    scrapepagegrocery(offset)
    offset=0
    scrapepagebeverage(offset)

if __name__ == "__main__":
    scrapelotus()
