# ProductSearcherAPI.py
from fastapi import FastAPI
import ProductSearcher  

app = FastAPI()

@app.get("/search")
def search(thing: str):
    items = ProductSearcher.search(thing)  
    return {"products": items}
