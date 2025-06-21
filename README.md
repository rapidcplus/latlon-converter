# 座標変換アプリ (10進法 → 60進法)

10進法の座標を60進法（度分秒）に変換するシンプルなWindows用デスクトップアプリケーションです。

### 座標変換例
入力: 35.6762 (緯度), 139.6503 (経度) → 出力: 35°40'34.32"N, 139°39'1.08"E

---

## 🖥️クロスプラットフォーム対応の開発環境

###  Docker + X Server アーキテクチャ

- **Dockerによる完全コンテナ化**
- **X11 Forwarding**によるGUIアプリケーションの表示

---

### システム構成図

```
┌───────────────────────────────────────────────────────────────-──┐
│                        Host OS                                   │
│                   (macOS/Windows/Linux)                          │
│                                                                  │
│  ┌─────────────────┐              ┌─────────────────────────────┐│
│  │   X Server      │              │      Docker Container       ││
│  │                 │              │                             ││
│  │  ┌───────────┐  │    X11       │  ┌─────────────────────────┐││
│  │  │ XQuartz   │◄─┼──Protocol────┼──┤    Electron App         │││
│  │  │ VcXsrv    │  │              │  │                         │││
│  │  │ Xorg      │  │              │  │  ┌─────────────────────┐│││
│  │  └───────────┘  │              │  │  │       GUI           ││││
│  │                 │              │  │  │    Components       ││││
│  │  ┌───────────┐  │              │  │  └─────────────────────┘│││
│  │  │  Display  │  │              │  │                         │││
│  │  │  Manager  │  │              │  │  ┌─────────────────────┐│││
│  │  └───────────┘  │              │  │  │     Node.js         ││││
│  └─────────────────┘              │  │  │    Backend          ││││
│                                   │  │  └─────────────────────┘│││
│                                   │  └─────────────────────────┘││
│                                   └─────────────────────────────┘│
└────────────────────────────────────────────────────────────────-─┘
```

### X11 Forwarding の仕組み

1. **Docker Container内**: ElectronアプリがGUI描画要求を生成
2. **X11 Protocol**: ネットワーク経由でGUI情報を転送
3. **Host OS X Server**: 受信した描画命令を実際の画面に表示
4. **User Interaction**: マウス・キーボード入力を逆方向に転送

---

## 🚀 環境別セットアップガイド

### 📱 macOS

#### 前提条件

```bash
# Homebrewがインストールされていること
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 1. XQuartzのインストール
brew install --cask xquartz

# 2. Docker Desktopのインストール
brew install --cask docker

# 3. XQuartzの設定
# XQuartz起動後、環境設定 → セキュリティ → 
# "ネットワーククライアントからの接続を許可" をチェック

# 4. XQuartzの再起動
# ログアウト/ログインまたはシステム再起動

# 5. 権限設定
xhost +localhost

# 6. プロジェクトのクローン・起動
git clone <repository-url>
cd latlon-converter
docker-compose up --build
```

### 🪟 Windows 10/11

#### 前提条件
- Windows Subsystem for Linux (WSL2) 有効化
- Docker Desktop for Windows

#### セットアップ手順

```bash
# 1. VcXsrvのインストール (PowerShellを管理者権限で実行)
winget install VcXsrv

# または手動ダウンロード
# https://sourceforge.net/projects/vcxsrv/

# 2. Docker Desktop for Windowsのインストール
winget install Docker.DockerDesktop
```

#### VcXsrv設定

```
# VcXsrv起動時の設定
Display number: 0
Start no client: チェック
Clipboard: チェック
Primary Selection: チェック
Native opengl: チェック
Disable access control: チェック ⚠️(開発時のみ)
```

#### 環境変数設定

```bash
# WSL2内で実行
export DISPLAY=host.docker.internal:0

# または.bashrcに追加
echo 'export DISPLAY=host.docker.internal:0' >> ~/.bashrc
source ~/.bashrc
```

#### プロジェクト起動

```bash
git clone <repository-url>
cd latlon-converter
docker-compose up --build
```

## 🔧 プロジェクト構成

```
latlon-converter/
├── README.md                # このファイル
├── package.json             # Node.js依存関係
├── docker-compose.yml       # Docker設定
├── Dockerfile               # コンテナイメージ定義
├── main.js                  # Electronメインプロセス
├── renderer.js              # レンダラープロセス
├── preload.js               # プリロードスクリプト
└── index.html               # フロントエンドUI
```

### 技術スタック
- Docker: コンテナ化プラットフォーム
- Electron: デスクトップアプリケーションフレームワーク
- Node.js: JavaScript実行環境
- X11: GUI表示プロトコル

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Electron](https://img.shields.io/badge/Electron-47848F?style=for-the-badge&logo=electron&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)


## 🚀 使用方法

### 基本的な起動

```bash
# 開発環境起動
docker-compose up --build

# バックグラウンド実行
docker-compose up -d --build

# 停止
docker-compose down
```

### 開発時のコマンド

```bash
# コンテナに入る
docker exec -it latlon-converter-dev bash

# ログ確認
docker-compose logs -f

# 完全リビルド
docker-compose down
docker-compose build --no-cache
docker-compose up
```

## 🔍 トラブルシューティング

### ❌ よくある問題

#### 1. 「No protocol specified」エラー

```bash
# 解決方法
xhost +localhost  # macOS
xhost +local:docker  # Linux
```

#### 2. アプリケーションが表示されない

```bash
# DISPLAY環境変数確認
echo $DISPLAY

# X Serverの動作確認
# macOS: XQuartzが起動しているか確認
# Windows: VcXsrvが起動しているか確認
# Linux: echo $DISPLAY で値が設定されているか確認
```

#### 3. 文字化け (日本語フォント問題)

```bash
# コンテナ内でフォント確認
docker exec -it latlon-converter-dev fc-list | grep -i "noto\|takao"

# フォントキャッシュ更新
docker exec -it latlon-converter-dev fc-cache -fv
```

#### 4. Docker接続エラー

```bash
# Dockerサービス確認
docker --version
docker-compose --version

# Docker Desktop起動確認 (macOS/Windows)
# Dockerサービス起動確認 (Linux)
sudo systemctl status docker
```

## 🔧 デバッグ方法

### X11接続テスト

```bash
# コンテナ内でX11アプリ起動テスト
docker exec -it latlon-converter-dev bash
apt-get update && apt-get install -y x11-apps
xclock  # 時計アプリが表示されれば成功
```

### Electron開発者ツール

```javascript
// main.jsに追加 (デバッグ時のみ)
mainWindow.webContents.openDevTools()
```
