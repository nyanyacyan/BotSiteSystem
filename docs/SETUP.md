# セットアップガイド

## 前提条件

開発環境をセットアップする前に、以下のツールをインストールしてください：

- **Docker**: 20.10以降
- **Docker Compose**: 2.0以降
- **Git**: 2.30以降
- **Python**: 3.10以降（ローカル開発の場合）
- **Node.js**: 16以降（ローカル開発の場合）

## クイックスタート

### 1. リポジトリのクローン

```bash
git clone https://github.com/nyanyacyan/BotSiteSystem.git
cd BotSiteSystem
```

### 2. 環境変数の設定

```bash
cp .env.example .env
```

`.env` ファイルを編集して、必要な環境変数を設定してください：

- `DJANGO_SECRET_KEY`: ランダムな文字列に変更
- データベースの認証情報（必要に応じて）
- n8nの認証情報（必要に応じて）

### 3. Dockerコンテナの起動

```bash
docker-compose up -d
```

これにより、以下のサービスが起動します：
- PostgreSQL（ポート5432）
- Redis（ポート6379）
- Django Backend（ポート8000）
- React Frontend（ポート3000）
- n8n（ポート5678）
- Celery Worker

### 4. データベースの初期化

```bash
# マイグレーションの実行
docker-compose exec backend python manage.py migrate

# スーパーユーザーの作成
docker-compose exec backend python manage.py createsuperuser
```

### 5. アプリケーションへのアクセス

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Django Admin**: http://localhost:8000/admin
- **n8n**: http://localhost:5678

## ローカル開発（Docker不使用）

### バックエンド

```bash
cd backend

# 仮想環境の作成
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 依存関係のインストール
pip install -r requirements.txt

# 環境変数の設定
export DJANGO_SETTINGS_MODULE=config.settings.development

# データベースの作成（PostgreSQLが必要）
createdb botsite_db

# マイグレーション
python manage.py migrate

# 開発サーバーの起動
python manage.py runserver
```

### フロントエンド

```bash
cd frontend

# 依存関係のインストール
npm install

# 開発サーバーの起動
npm start
```

## トラブルシューティング

### ポートが既に使用されている

他のサービスがポートを使用している場合、`docker-compose.yml` のポート設定を変更してください。

### データベース接続エラー

- PostgreSQLコンテナが起動しているか確認: `docker-compose ps`
- データベース認証情報が正しいか確認

### n8nにアクセスできない

- n8nコンテナが起動しているか確認
- ブラウザのキャッシュをクリア
- コンテナログを確認: `docker-compose logs n8n`

## 次のステップ

- [開発ガイド](DEVELOPMENT.md)を参照して開発を開始
- [API ドキュメント](API.md)でAPI仕様を確認
- [デプロイガイド](DEPLOYMENT.md)で本番環境へのデプロイ方法を確認
