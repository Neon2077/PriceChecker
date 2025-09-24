import requests
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor, as_completed
import time
import sqlite3
import os
print("Pyautomation0speedup imported. __name__ =", __name__)

def scrapesunshine ():
    print("scraper0 function actually running")
    page=1
    products = []
    session=requests.Session()
    BASE_DIR = os.path.dirname(__file__)  # folder where ProductSearcher.py lives
    DB_PATH = os.path.join(BASE_DIR, "products.db")
    connect=sqlite3.connect(DB_PATH)     #connection to database file
    c = connect.cursor()        #cursor is like a tool in sqlite to perform action through python
    c.execute("""               
    CREATE TABLE IF NOT EXISTS products (
        sku TEXT PRIMARY KEY,
        name TEXT,
        link TEXT,
        brand TEXT,
        old_price TEXT,
        new_price TEXT,
        normal_price TEXT,
        stock TEXT
    )
    """)
    # c.execute("ALTER TABLE products ADD COLUMN image TEXT")
    connect.commit()            #save action

    def scrapepage(page):
        print("scraper0 function actually running")       
        product = []
        if page==1:
            url = "https://sunshineonline.com.my/ssq/index.php?route=product/catalog&bestseller=true&module_id=346"
        else:
            url= f"https://sunshineonline.com.my/ssq/product/catalog&bestseller=true&page={page}"   #this website load more is just changing link with diff page so we just scrape link with diff page
        for x in range(3):
            try:
                r = session.get(url)
                soup = BeautifulSoup(r.text, "html.parser")             #need to identify and inspect type of website(with inspect(network) or page source) first, where their data load from
                for item in soup.select("div.product-layout"):          #css selector to scrape data from html
                    name = item.select_one("div.name a").get_text(strip=True)
                    link = item.select_one("div.name a")["href"]
                    brand = item.select_one("span.stats-label:-soup-contains('Brand:')").find_next("a").get_text(strip=True)
                    sku = item.select_one("span.stats-label:-soup-contains('SKU:')").find_next("span").get_text(strip=True)
                    image = item.select_one("img")["data-src"]
                    price_old = item.select_one(".price-old")
                    price_new = item.select_one(".price-new")
                    price_normal = item.select_one(".price-normal")
                    stock=item.select_one("span.product-label.product-label-30.product-label-diagonal")     #in page source no'.' but is spacebar because it is html syntax, it means three class, but we use css selector we follow css syntax so replace with '.'
                    price_old = price_old.get_text(strip=True) if price_old else None
                    price_new = price_new.get_text(strip=True) if price_new else None
                    price_normal = price_normal.get_text(strip=True) if price_normal else None
                    stock=stock.get_text(strip=True) if stock else "In Stock"
                    product.append({
                            "name": name,
                            "link": link,
                            "brand": brand,
                            "sku": sku,
                            "image": image,
                            "old_price": price_old,
                            "new_price": price_new,
                            "normal_price":price_normal,
                            "stock":stock,
                            "image":image
                        })
                break
            except:
                print("Retrying...")
                time.sleep(2)
                pass

        return product
    x=True

    ref="1"
    if ref=="1":
        with ThreadPoolExecutor(max_workers=15) as executor:        #multi thread to speed up
            while x:
                futures={}  #data is saved then reset at another iteration
                for a in range(15):
                    futures[executor.submit(scrapepage, page)]=page #track page number of each product
                    page+=1

                for future in as_completed(futures):    #futures is like a cache 
                    pagenum=futures[future]
                    data = future.result()              #extract real data with .result from the cache
                    print(f"Data done from page {pagenum}")
                    if data:         # page had products
                        products.extend(data)
                        for b in range(15):
                            try:                                                                            #sqlite 
                                c.execute("INSERT OR REPLACE INTO products VALUES (?,?,?,?,?,?,?,?,?)",       #if exists, then replace the data with most recent fetched data
                                            (data[b]['sku'], data[b]['name'], data[b]['link'], data[b]['brand'], data[b]['old_price'], data[b]['new_price'], data[b]['normal_price'],data[b]["stock"],data[b]['image']))
                                connect.commit()
                                print(data[b]['name'])
                            except sqlite3.IntegrityError:
                            # SKU exists → you can optionally update prices
                                print(f"{data[b]['name']} already exist in database")
                                pass
                    else:
                        x=False

        for p in products:
            print(p["name"])

    thing=input("Searching for things(if no input '0')? ")
    if thing!=0:
        c.execute("SELECT name, old_price, new_price, normal_price, stock FROM products WHERE name like ?",( f"%{thing}%",))  #tuple so remember ','    , use like with % to look for similar not exact
        for row in c.fetchall():
            print(row)
            
if __name__ == "__main__":
    scrapesunshine()
