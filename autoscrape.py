import subprocess
import os
from datetime import datetime

repo_path = r"C:\Users\User\PriceChecker"

# 1️⃣ Run your scraper scripts
subprocess.run(["python", "Pyautomation0api_data.py"], check=True)
subprocess.run(["python", "Pyautomation0api_data2.py"], check=True)
subprocess.run(["python", "Pyautomation0speedup.py"], check=True)

# 2️⃣ Switch to repo directory
os.chdir(repo_path)

# 3️⃣ Fetch latest remote (no merge, no rebase)
subprocess.run(["git", "fetch"], check=True)

# 4️⃣ Ensure local version of products.db is kept
subprocess.run(["git", "checkout", "--ours", "products.db"], check=False)

# 5️⃣ Stage only products.db
subprocess.run(["git", "add", "products.db"], check=True)

# 6️⃣ Commit with timestamp
commit_message = f"Auto update {datetime.now():%Y-%m-%d %H:%M:%S}"
result = subprocess.run(["git", "commit", "-m", commit_message])
if result.returncode != 0:
    print("Nothing to commit.")
else:
    # 7️⃣ Push changes
    push = subprocess.run(["git", "push"])
    if push.returncode == 0:
        print("✅ products.db pushed to GitHub.")
    else:
        print("⚠️ Push failed. You may need --force-with-lease.")
