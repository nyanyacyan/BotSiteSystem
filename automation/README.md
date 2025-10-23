# n8n 自動化ワークフロー

## 概要

n8nは、BotSiteSystemの自動化エンジンとして機能します。以下のような自動化を実現します：

- 注文通知の自動送信
- 在庫アラート
- 定期的なレポート生成
- 外部API連携
- Bot通知（Slack, Discord, Email等）

## セットアップ

### ローカル開発環境

1. Docker Composeで起動
```bash
docker-compose up -d n8n
```

2. n8nにアクセス
- URL: http://localhost:5678
- ユーザー名: admin (デフォルト)
- パスワード: admin (デフォルト)

### ワークフロー

ワークフローは `automation/workflows/` ディレクトリに保存されます。

## 主要なワークフロー例

### 1. 注文通知ワークフロー

**トリガー**: Djangoからのwebhook  
**アクション**:
- 注文データの取得
- Slack/Discordへの通知送信
- メール送信

### 2. 在庫監視ワークフロー

**トリガー**: スケジュール（1時間ごと）  
**アクション**:
- 在庫レベルのチェック
- 低在庫の検出
- アラート通知の送信

### 3. データバックアップワークフロー

**トリガー**: スケジュール（毎日深夜）  
**アクション**:
- データベースのエクスポート
- S3へのアップロード
- 完了通知の送信

## Django統合

### Webhookの送信

Djangoアプリケーションからn8nにwebhookを送信する例：

```python
import requests

def send_order_notification(order_data):
    webhook_url = settings.N8N_WEBHOOK_URL + '/order-notification'
    headers = {'Content-Type': 'application/json'}
    
    response = requests.post(
        webhook_url,
        json=order_data,
        headers=headers
    )
    return response.status_code == 200
```

## セキュリティ

- Basic認証を有効化
- Webhook URLは環境変数で管理
- 本番環境ではHTTPSを使用
- APIキーによる認証

## トラブルシューティング

### ワークフローが実行されない
- n8nコンテナのログを確認: `docker-compose logs n8n`
- Webhook URLが正しいか確認
- 認証情報が正しいか確認

### 通知が届かない
- 通知サービスの認証情報を確認
- ネットワーク接続を確認
- n8nのエラーログを確認
