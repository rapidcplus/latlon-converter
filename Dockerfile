FROM node:20

# --- Electronの依存ライブラリをインストール ---
# パッケージリストを更新し、必要なライブラリをインストール
# (--no-install-recommends は推奨パッケージを除外して軽量化)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgtk-3-0 \
    libnotify4 \
    libnss3 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    libatspi2.0-0 \
    libuuid1 \
    libsecret-1-0 \
    libgbm1 \
    libasound2 \
    libglib2.0-0 \
    # 不要になったキャッシュファイルを削除
    && rm -rf /var/lib/apt/lists/*
# --- ここまで追加 ---

# 2. アプリケーション用のディレクトリを作成・設定
WORKDIR /app

# 3. 最初に package.json と lock ファイルをコピー (キャッシュを活用するため)
COPY package*.json ./

# 4. 依存関係をインストール
# RUN npm install
RUN npm ci 

# 5. アプリケーションのソースコードをコピー
COPY . .

# 6. (オプション) アプリケーションが特定のポートを使う場合 (Webサーバー機能など)
# EXPOSE 3000

# 7. コンテナ起動時に実行するデフォルトコマンド
CMD [ "npm", "start" ]
