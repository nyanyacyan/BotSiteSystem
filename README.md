# BotSiteSystem

**自動化EC・管理プラットフォーム**

Django × React × n8n × AWS を用いた、Botによる自動化を組み込んだWebアプリ構築基盤

## 📋 プロジェクト概要

### 目的
個人販売者・小規模事業者のための「自動化EC・管理プラットフォーム」を提供します。  
Bot通知・API連携・クラウド運用を一体化した"自動化型Webアプリ"を実現します。

### システム構成

| 項目 | 内容 |
|------|------|
| **プロジェクト名** | BotSiteSystem |
| **目的** | Webアプリ（EC・予約・管理など）にBot自動化を組み込む基盤を構築 |
| **技術スタック** | Django（バックエンド）＋ React（フロントエンド）＋ n8n（自動化）＋ AWS（運用） |
| **特徴** | Bot通知・API連携・クラウド運用を一体化した"自動化型Webアプリ" |
| **構築スタイル** | Dockerベースのローカル開発 → AWSデプロイ（EC2＋RDS＋S3） |

## 🏗️ ディレクトリ構成

```
BotSiteSystem/
├── backend/              # Django バックエンド
│   ├── config/          # Django プロジェクト設定
│   ├── apps/            # Django アプリケーション
│   ├── requirements.txt # Python 依存関係
│   └── manage.py        # Django 管理コマンド
├── frontend/            # React フロントエンド
│   ├── public/          # 静的ファイル
│   ├── src/             # React ソースコード
│   └── package.json     # Node.js 依存関係
├── automation/          # n8n 自動化ワークフロー
│   ├── workflows/       # n8n ワークフロー定義
│   └── README.md        # n8n 設定ガイド
├── deployment/          # デプロイメント設定
│   ├── docker/          # Docker 設定
│   └── aws/             # AWS デプロイ設定
├── docs/                # ドキュメント
└── README.md            # このファイル
```

## 🚀 クイックスタート

### 前提条件

- Docker & Docker Compose
- Python 3.10+
- Node.js 16+
- Git

### ローカル開発環境のセットアップ

1. **リポジトリのクローン**
```bash
git clone https://github.com/nyanyacyan/BotSiteSystem.git
cd BotSiteSystem
```

2. **環境変数の設定**
```bash
cp .env.example .env
# .env ファイルを編集して必要な環境変数を設定
```

3. **Dockerコンテナの起動**
```bash
docker-compose up -d
```

4. **データベースのマイグレーション**
```bash
docker-compose exec backend python manage.py migrate
```

5. **管理者ユーザーの作成**
```bash
docker-compose exec backend python manage.py createsuperuser
```

6. **アプリケーションへのアクセス**
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- n8n Automation: http://localhost:5678
- Django Admin: http://localhost:8000/admin

## 🔧 技術スタック詳細

### バックエンド (Django)
- **フレームワーク**: Django 4.2+
- **API**: Django REST Framework
- **データベース**: PostgreSQL
- **認証**: JWT (JSON Web Tokens)
- **ストレージ**: AWS S3 (本番環境)

### フロントエンド (React)
- **ライブラリ**: React 18+
- **状態管理**: Redux Toolkit
- **ルーティング**: React Router
- **UI フレームワーク**: Material-UI / Tailwind CSS
- **HTTP クライアント**: Axios

### 自動化 (n8n)
- **ワークフロー自動化**: n8n
- **通知**: Slack, Discord, Email
- **API 連携**: 各種外部サービス
- **スケジューリング**: Cron ベース

### インフラ (AWS)
- **コンピューティング**: EC2
- **データベース**: RDS (PostgreSQL)
- **ストレージ**: S3
- **ネットワーク**: VPC, Security Groups
- **ロードバランサー**: ALB (Application Load Balancer)

## 📚 ドキュメント

詳細なドキュメントは `docs/` ディレクトリを参照してください：

- [セットアップガイド](docs/SETUP.md)
- [開発ガイド](docs/DEVELOPMENT.md)
- [デプロイガイド](docs/DEPLOYMENT.md)
- [API ドキュメント](docs/API.md)
- [n8n ワークフロー](docs/N8N_WORKFLOWS.md)

## 🔐 セキュリティ

- すべての機密情報は環境変数で管理
- HTTPS/TLS 通信の使用
- CORS 設定の適切な構成
- 定期的なセキュリティアップデート

## 🤝 コントリビューション

プロジェクトへの貢献を歓迎します！以下の手順に従ってください：

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/AmazingFeature`)
3. 変更をコミット (`git commit -m 'Add some AmazingFeature'`)
4. ブランチにプッシュ (`git push origin feature/AmazingFeature`)
5. プルリクエストを作成

## 📝 ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。

## 👥 開発者

- **プロジェクトオーナー**: nyanyacyan

## 🙏 謝辞

このプロジェクトは以下の技術を活用しています：
- Django & Django REST Framework
- React & Redux
- n8n
- AWS
- Docker