# ProductSearcherAPI.py
from fastapi import FastAPI
import ProductSearcher  
import sqlite3
import os
app = FastAPI()

@app.get("/")          # <-- add this
def root():
    return {"status": "ok", "message": "API is running"}

@app.get("/search")
def search(thing: str):
    items = ProductSearcher.search(thing)  
    return {"products": items}

@app.get("/products")
def view_all_products():
    BASE_DIR = os.path.dirname(__file__)  # folder where ProductSearcher.py lives
    DB_PATH = os.path.join(BASE_DIR, "products.db")
    connect=sqlite3.connect(DB_PATH)
    c = connect.cursor()
    items1=[]
    c.execute("SELECT name, new_price, normal_price,old_price, stock, image,link FROM products")  #tuple so remember ','    , use like with % to look for similar not exact
    for row in c.fetchall():
        name,discounted_price,normal_price,original_price,stock,image,link=row
        if normal_price is None:
            finalprice0=discounted_price
            initialprice0=original_price
            print(f"{name}, {finalprice0}, {initialprice0}, {stock}, {image}, {link} from SUNSHINE")
            item1={"Market":"Sunshine", "name":name,"final price":finalprice0,"original price":initialprice0,"stock":stock,"image":image,"link":link}
            items1.append(item1)
        else:
            finalprice0=normal_price
            print(f"{name}, {finalprice0}, {stock}, {image}, {link} from SUNSHINE")
            item1={"Market":"SUNSHINE", "name":name,"final price":finalprice0,"stock":stock,"image":image,"link":link}
            items1.append(item1)

    c.execute("SELECT name,final_price, normal_price, link FROM mydinproducts")  #tuple so remember ','    , use like with % to look for similar not exact
    for row in c.fetchall():
        name,discounted_price,original_price,image=row
        if original_price == discounted_price:
            finalprice1="RM "+discounted_price
            print(f"{name}, {finalprice1}, {image} from MYDIN")
            item1={"Market":"MYDIN", "name":name,"final price":finalprice1,"image":image}
            items1.append(item1)
        else:
            finalprice1="RM "+discounted_price
            initialprice1="RM "+original_price
            print(f"{name}, {finalprice1}, {initialprice1}, {image} from MYDIN")
            item1={"Market":"MYDIN", "name":name,"final price":finalprice1, "original price":initialprice1, "image":image}
            items1.append(item1)

    c.execute("SELECT name, final_price, normal_price, stock, link FROM lotusproducts")  #tuple so remember ','    , use like with % to look for similar not exact
    for row in c.fetchall():            #object is pack into tuple at c then print the object which is one tuple in c
        name,discounted_price,original_price,stock,image=row
        if original_price == discounted_price:
            finalprice2="RM "+discounted_price
            print(f"{name}, {finalprice2}, {stock}, {image} from LOTUS")
            item1={"Market":"LOTUS","name":name,"final price":finalprice2, "stock":stock, "image":image}
            items1.append(item1)
        else:
            finalprice2="RM "+discounted_price
            initialprice2="RM "+original_price
            print(f"{name}, {finalprice2}, {initialprice2}, {stock}, {image} from LOTUS")
            item1={"Market":"LOTUS","name":name,"final price":finalprice2, "original price":initialprice2, "stock":stock, "image":image}
            items1.append(item1)
    return  {"products": items1}
