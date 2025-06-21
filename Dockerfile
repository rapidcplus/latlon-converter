FROM node:18-bullseye

# GUI表示に必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    libgtk-3-0 \
    libgbm-dev \
    libxss1 \
    libasound2 \
    libxtst6 \
    libxrandr2 \
    libasound2-dev \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxfixes3 \
    libxi6 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    fonts-liberation \
    libappindicator1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# package.jsonをコピーして依存関係をインストール
COPY package*.json ./
RUN npm install

# アプリケーションコードをコピー
COPY . .

# Electronを非rootユーザーで実行するための設定
RUN groupadd -r electron && useradd -r -g electron -G audio,video electron \
    && mkdir -p /home/electron && chown -R electron:electron /home/electron \
    && chown -R electron:electron /app

USER electron

CMD ["npm", "start"]
