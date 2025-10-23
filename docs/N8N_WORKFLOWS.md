# n8n ワークフロードキュメント

## 概要

このドキュメントでは、BotSiteSystemで使用される主要なn8nワークフローについて説明します。

## ワークフロー一覧

### 1. 注文通知ワークフロー

**ファイル**: `automation/workflows/order-notification.json`

**目的**: 新しい注文が作成されたときに、Slack/Discord/Emailで通知を送信

**トリガー**: Webhook (`/webhook/order-notification`)

**フロー**:
1. Djangoから注文データを受信
2. Slackに注文通知を送信
3. 顧客にメールで注文確認を送信

**必要な設定**:
- Slack Webhook URL
- Email送信設定（SMTP）

**Djangoからの呼び出し例**:
```python
import requests
from django.conf import settings

def notify_new_order(order):
    data = {
        'order_id': order.id,
        'customer_name': order.customer.username,
        'customer_email': order.customer.email,
        'total_amount': str(order.total_amount),
    }
    
    webhook_url = f"{settings.N8N_WEBHOOK_URL}/order-notification"
    requests.post(webhook_url, json=data)
```

### 2. 在庫監視ワークフロー

**目的**: 在庫レベルを定期的にチェックし、低在庫の場合にアラートを送信

**トリガー**: Cron (1時間ごと)

**フロー**:
1. Django APIから商品データを取得
2. 在庫が閾値以下の商品をフィルタリング
3. 管理者にアラート通知を送信

**必要な設定**:
- Django API エンドポイント
- 在庫閾値（例: 5個以下）
- 通知先（Slack/Email）

### 3. 日次レポート生成ワークフロー

**目的**: 毎日の売上レポートを生成して管理者に送信

**トリガー**: Cron (毎日深夜2時)

**フロー**:
1. Django APIから当日の注文データを取得
2. データを集計・整形
3. レポートをメール/Slackで送信

### 4. 顧客フォローアップワークフロー

**目的**: 注文から一定期間後にレビュー依頼を送信

**トリガー**: Cron (1日1回)

**フロー**:
1. 配達完了から7日経過した注文を取得
2. まだレビューしていない顧客をフィルタリング
3. レビュー依頼メールを送信

## ワークフロー作成ガイド

### 基本的な構造

```
Trigger → Data Processing → Action
```

### よく使うノード

#### 1. Webhook ノード
- Djangoからのリクエストを受信
- HTTPリクエストをトリガーとして使用

#### 2. HTTP Request ノード
- Django APIを呼び出し
- 外部APIと連携

#### 3. Function ノード
- JavaScriptでデータを加工
- 条件分岐やフィルタリング

#### 4. Slack/Discord ノード
- チャットツールに通知送信

#### 5. Email Send ノード
- メール送信

#### 6. Schedule Trigger ノード
- 定期実行（Cron）

### ワークフロー例: 在庫アラート

```javascript
// Function ノードでの処理例
const lowStockThreshold = 5;
const products = items[0].json.results;

const lowStockProducts = products.filter(
  product => product.stock <= lowStockThreshold
);

if (lowStockProducts.length > 0) {
  return lowStockProducts.map(product => ({
    json: {
      name: product.name,
      stock: product.stock,
      message: `${product.name}の在庫が${product.stock}個になりました`
    }
  }));
}

return [];
```

## Django統合パターン

### パターン1: Webhook経由での通知

```python
# Django signals.py
from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Order
import requests

@receiver(post_save, sender=Order)
def notify_order_created(sender, instance, created, **kwargs):
    if created:
        webhook_url = f"{settings.N8N_WEBHOOK_URL}/order-notification"
        data = {
            'order_id': instance.id,
            'customer_email': instance.customer.email,
            'total_amount': str(instance.total_amount),
        }
        requests.post(webhook_url, json=data)
```

### パターン2: APIポーリング

n8nから定期的にDjango APIをポーリング

```
Schedule Trigger → HTTP Request (Django API) → Process Data → Notification
```

### パターン3: 双方向連携

n8nからDjango APIを呼び出し、結果をDjangoに返す

## セキュリティ設定

### Basic認証の有効化

```bash
# docker-compose.yml
environment:
  - N8N_BASIC_AUTH_ACTIVE=true
  - N8N_BASIC_AUTH_USER=admin
  - N8N_BASIC_AUTH_PASSWORD=secure_password
```

### Webhook認証

```python
# Django側での検証
import hmac
import hashlib

def verify_webhook_signature(request, secret):
    signature = request.headers.get('X-N8N-Signature')
    body = request.body.decode('utf-8')
    
    expected_signature = hmac.new(
        secret.encode(),
        body.encode(),
        hashlib.sha256
    ).hexdigest()
    
    return hmac.compare_digest(signature, expected_signature)
```

## ベストプラクティス

1. **エラーハンドリング**
   - すべてのHTTPリクエストにエラーハンドリングを追加
   - 失敗時のリトライロジックを実装

2. **ログ記録**
   - 重要なアクションはログに記録
   - デバッグモードでワークフローをテスト

3. **環境変数の使用**
   - API URLや認証情報は環境変数で管理
   - ハードコーディングを避ける

4. **テスト**
   - 本番デプロイ前に必ずテスト
   - 手動トリガーでワークフローを検証

5. **ドキュメント**
   - ワークフローの目的と動作を文書化
   - 変更履歴を記録

## トラブルシューティング

### ワークフローが実行されない

1. n8nの実行履歴を確認
2. トリガーの設定を確認
3. Webhookの場合、URLが正しいか確認

### 通知が送信されない

1. 通知サービスの認証情報を確認
2. ネットワーク接続を確認
3. エラーログを確認

### データが正しく処理されない

1. Function ノードでデバッグ出力を追加
2. 各ノードの出力データを確認
3. データ型と構造を検証

## 参考資料

- [n8n公式ドキュメント](https://docs.n8n.io/)
- [n8nコミュニティフォーラム](https://community.n8n.io/)
- [ワークフローテンプレート](https://n8n.io/workflows)
