FROM node:18-bullseye

# 日本語フォントと GUI表示に必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    dbus-x11 \
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
    x11-utils \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    fonts-takao-gothic \
    fonts-takao-mincho \
    && rm -rf /var/lib/apt/lists/*

# フォントキャッシュを更新
RUN fc-cache -fv

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# DBusサービスを開始するスクリプトを作成
RUN echo '#!/bin/bash\n\
mkdir -p /run/dbus\n\
dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address\n\
exec "$@"' > /entrypoint.sh && chmod +x /entrypoint.sh

RUN groupadd -r electron && useradd -r -g electron -G audio,video electron \
    && mkdir -p /home/electron && chown -R electron:electron /home/electron \
    && chown -R electron:electron /app

USER electron

ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "start"]
