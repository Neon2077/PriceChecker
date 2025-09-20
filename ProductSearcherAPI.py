# ProductSearcherAPI.py
from fastapi import FastAPI
import ProductSearcher  

app = FastAPI()

@app.get("/")          # <-- add this
def root():
    return {"status": "ok", "message": "API is running"}
    
@app.get("/search")
def search(thing: str):
    items = ProductSearcher.search(thing)  
    return {"products": items}
