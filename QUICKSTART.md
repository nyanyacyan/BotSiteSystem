# クイックスタートガイド

このガイドでは、BotSiteSystemを最速でセットアップして動作させる手順を説明します。

## 前提条件

- Docker & Docker Compose がインストールされていること
- Git がインストールされていること

## セットアップ手順

### 1. リポジトリのクローン

```bash
git clone https://github.com/nyanyacyan/BotSiteSystem.git
cd BotSiteSystem
```

### 2. 環境変数の設定

```bash
cp .env.example .env
```

`.env` ファイルを編集して、最低限以下の設定を変更：

```env
DJANGO_SECRET_KEY=ランダムな文字列に変更してください
DB_PASSWORD=安全なパスワードに変更してください
N8N_PASSWORD=安全なパスワードに変更してください
```

### 3. Dockerコンテナの起動

```bash
docker-compose up -d
```

初回起動時は、イメージのダウンロードとビルドに時間がかかります。

### 4. データベースのセットアップ

```bash
# マイグレーションの実行
docker-compose exec backend python manage.py migrate

# スーパーユーザーの作成
docker-compose exec backend python manage.py createsuperuser
```

ユーザー名、メールアドレス、パスワードを入力してください。

### 5. アプリケーションへのアクセス

以下のURLにブラウザでアクセスできます：

- **Frontend**: http://localhost:3000
  - Reactアプリケーション

- **Backend API**: http://localhost:8000/api
  - REST API エンドポイント

- **Django Admin**: http://localhost:8000/admin
  - 管理画面（ステップ4で作成したユーザーでログイン）

- **n8n**: http://localhost:5678
  - 自動化ワークフロー（ユーザー名: admin、パスワード: .envで設定）

### 6. テストデータの作成（オプション）

Django管理画面から、商品や注文のテストデータを作成できます。

## 次のステップ

- [セットアップガイド](docs/SETUP.md) - 詳細なセットアップ手順
- [開発ガイド](docs/DEVELOPMENT.md) - 開発を始める
- [API ドキュメント](docs/API.md) - API仕様の確認
- [n8n ワークフロー](docs/N8N_WORKFLOWS.md) - 自動化の設定

## トラブルシューティング

### コンテナが起動しない

```bash
# ログを確認
docker-compose logs

# 特定のサービスのログを確認
docker-compose logs backend
docker-compose logs frontend
```

### ポート競合

既に使用されているポートがある場合は、`docker-compose.yml` の `ports` 設定を変更してください。

### データベース接続エラー

```bash
# コンテナを再起動
docker-compose restart

# または完全に再作成
docker-compose down
docker-compose up -d
```

## コンテナの停止と削除

```bash
# コンテナを停止
docker-compose stop

# コンテナを停止して削除
docker-compose down

# ボリュームも含めて削除（データが消えます！）
docker-compose down -v
```
