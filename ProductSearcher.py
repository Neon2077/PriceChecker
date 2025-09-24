import sqlite3
# import pandas as pd
from Pyautomation0speedup import scrapesunshine
from Pyautomation0api_data import scrapelotus
from Pyautomation0api_data2 import scrapemydin

# sunshine=pd.read_sql("SELECT sku, name,link, new_price, normal_price,stock,image FROM products", connect)     #not needed because pandas for data analysis and every item has diff sku and name among diff companies
# mydin=pd.read_sql("SELECT sku, name,link, final_price, normal_price FROM mydinproducts", connect)
# lotus=pd.read_sql("SELECT sku, name,link, final_price, normal_price,stock FROM lotusproducts", connect)
BASE_DIR = os.path.dirname(__file__)  # folder where ProductSearcher.py lives
DB_PATH = os.path.join(BASE_DIR, "products.db")
def search(thing):
    connect=sqlite3.connect(DB_PATH)     #connection to database file
    items=[]
    c = connect.cursor()
    # thing=input("Searching for things(if no input '0')? ")            #use api to give input
    if thing!="0":
        c.execute("SELECT name, new_price, normal_price,old_price, stock, image,link FROM products WHERE name like ?",( f"%{thing}%",))  #tuple so remember ','    , use like with % to look for similar not exact
        for row in c.fetchall():
            name,discounted_price,normal_price,original_price,stock,image,link=row
            if normal_price is None:
                finalprice0=discounted_price
                initialprice0=original_price
                print(f"{name}, {finalprice0}, {initialprice0}, {stock}, {image}, {link} from SUNSHINE")
                item={"Market":"Sunshine", "name":name,"final price":finalprice0,"original price":initialprice0,"stock":stock,"image":image,"link":link}
                items.append(item)
            else:
                finalprice0=normal_price
                print(f"{name}, {finalprice0}, {stock}, {image}, {link} from SUNSHINE")
                item={"Market":"SUNSHINE", "name":name,"final price":finalprice0,"stock":stock,"image":image,"link":link}
                items.append(item)

        c.execute("SELECT name,final_price, normal_price, link FROM mydinproducts WHERE name like ?",( f"%{thing}%",))  #tuple so remember ','    , use like with % to look for similar not exact
        for row in c.fetchall():
            name,discounted_price,original_price,image=row
            if original_price == discounted_price:
                finalprice1="RM "+discounted_price
                print(f"{name}, {finalprice1}, {image} from MYDIN")
                item={"Market":"MYDIN", "name":name,"final price":finalprice1,"image":image}
                items.append(item)
            else:
                finalprice1="RM "+discounted_price
                initialprice1="RM "+original_price
                print(f"{name}, {finalprice1}, {initialprice1}, {image} from MYDIN")
                item={"Market":"MYDIN", "name":name,"final price":finalprice1, "original price":initialprice1, "image":image}
                items.append(item)

        c.execute("SELECT name, final_price, normal_price, stock, link FROM lotusproducts WHERE name like ?",( f"%{thing}%",))  #tuple so remember ','    , use like with % to look for similar not exact
        for row in c.fetchall():            #object is pack into tuple at c then print the object which is one tuple in c
            name,discounted_price,original_price,stock,image=row
            if original_price == discounted_price:
                finalprice2="RM "+discounted_price
                print(f"{name}, {finalprice2}, {stock}, {image} from LOTUS")
                item={"Market":"LOTUS","name":name,"final price":finalprice2, "stock":stock, "image":image}
                items.append(item)
            else:
                finalprice2="RM "+discounted_price
                initialprice2="RM "+original_price
                print(f"{name}, {finalprice2}, {initialprice2}, {stock}, {image} from LOTUS")
                item={"Market":"LOTUS","name":name,"final price":finalprice2, "original price":initialprice2, "stock":stock, "image":image}
                items.append(item)
    return  items

if __name__ == "__main__":      #prevent once import then keep running
    search()

