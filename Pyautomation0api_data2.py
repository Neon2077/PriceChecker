import requests
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor, as_completed
import sqlite3
import json
from urllib.parse import quote
print("Pyautomation0(api data2) imported. __name__ =", __name__)
def scrapemydin():
    page=1
    print("scraper2 function actually running")

    connect=sqlite3.connect(r"C:\Users\User\Documents\products.db")     #connection to database file
    c = connect.cursor()        #cursor is like a tool in sqlite to perform action through python
    c.execute("""
    CREATE TABLE IF NOT EXISTS mydinproducts (
        sku TEXT PRIMARY KEY,
        name TEXT,
        link TEXT,
        final_price TEXT,
        normal_price TEXT
    )
    """)
    # c.execute("ALTER TABLE products ADD COLUMN stock TEXT")
    connect.commit()            #save action
    def scrapepage(page):
        print("scraper2 function actually running")       
        data = {}
        while True:
            payload = [     #what data u want from api
        {
            "filter": {"category_id": {"eq": 54}},
            "pageSize": 48,
            "currentPage": page,
            "sort": {"position": "ASC"}
        },
        {
            "products": "products-custom-query",
            "metadata": {
                "fields": """
                items {
                    sku
                    name
                    image {
                        url
                        label
                    }
                    thumbnail {
                        url
                        label
                    }
                    price_range {
                        minimum_price {
                            final_price { value currency }
                            regular_price { value currency }
                        }
                    }
                    salable_quantity
                }
                page_info { current_page page_size total_pages }
                total_count
                """
            }
        },
        {}
    ]
            headers = {
        "accept": "application/json, text/plain, */*",
        "origin": "https://www.mydin.my",
        "referer": "https://www.mydin.my/",
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0",
        "cookie": "_ga=GA1.1.2045306070.1758170343; _ga_EJEK8GE80C=GS2.1.s1758267888$o3$g1$t1758267888$j60$l0$h0"
    }
            url = (
            "https://myapi.mydin.my/magento/products"
            + "?body=" + quote(json.dumps(payload)))
        
            resp = requests.get(url,headers=headers)
            data = resp.json()
            a=data["data"]["products"]["items"]
            print(data)
            for x in a:
                print(x["name"])
                try:                                                                            #sqlite 
                    c.execute("INSERT OR REPLACE INTO mydinproducts VALUES (?,?,?,?,?)",       #if exists, then replace the data with most recent fetched data
                            (x['sku'], x['name'], x["thumbnail"]["url"], x["price_range"]["minimum_price"]['final_price']["value"], x["price_range"]["minimum_price"]["regular_price"]["value"]))
                    connect.commit()

                except KeyError:
                            # SKU exists → you can optionally update prices
                    print( f"{x['name']} has bug")
                    pass
            page+=1
            if page>int(data["data"]["products"]["page_info"]["total_pages"]):
                break
    scrapepage(page)

if __name__ == "__main__":
    scrapemydin()