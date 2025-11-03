# 使用 Python 3.11 精簡版
FROM python:3.11-slim

# 安裝 OpenCV 相關相依套件
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 libsm6 libxrender1 libxext6 libgl1 \
    && rm -rf /var/lib/apt/lists/*

# 設定工作目錄
WORKDIR /app

# 先安裝套件，利用快取機制加速後續 Build
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 複製全部程式碼到容器中
COPY . .

# 不緩衝輸出，Render Log 即時顯示
ENV PYTHONUNBUFFERED=1

# Render 會自動給你 PORT 環境變數
CMD gunicorn app:app -w 1 -k gthread --threads 1 -b 0.0.0.0:$PORT --timeout 180


