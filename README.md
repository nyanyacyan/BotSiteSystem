
# BotSiteSystem - 全体構築概要

目的：
Django × React × n8n × AWS を用いた、
「Botによる自動化を組み込んだWebアプリ構築基盤」
個人販売者・小規模事業者のための “自動化EC・管理プラットフォーム”

⸻

## システム概要

項目	内容
プロジェクト名	BotSiteSystem
目的	Webアプリ（EC・予約・管理など）にBot自動化を組み込む基盤を構築
技術スタック	Django（バックエンド）＋ React（フロントエンド）＋ n8n（自動化）＋ AWS（運用）
特徴	Bot通知・API連携・クラウド運用を一体化した“自動化型Webアプリ”
構築スタイル	Dockerベースのローカル開発 → AWSデプロイ（EC2＋RDS＋S3）




## システム構成図（論理構造）
```
📦 BotSiteSystem
├── backend/ (Django)
│   ├── manage.py
│   ├── bot_site_system/     ← Djangoメイン設定
│   ├── core/                ← 共通モジュール・API
│   ├── users/               ← 認証・ユーザー管理
│   ├── orders/              ← 受注・在庫管理
│   └── notifications/       ← n8n連携・Webhook
│
├── frontend/ (React)
│   ├── src/
│   │   ├── pages/           ← トップ／受注／在庫ページ
│   │   ├── components/      ← 共通UI
│   │   ├── api/             ← Django API通信用axios
│   │   └── hooks/           ← 状態管理
│   └── package.json
│
├── db/
│   └── data/                ← PostgreSQL 永続データ
│
├── docker-compose.yml
├── .env
└── README_DOCKER_SETUP.md
```



## 技術構成と役割

要素	技術	役割
バックエンド	Django + Django REST Framework	API提供・DB操作・認証
フロントエンド	React (Vite構築)	UI・操作画面・API通信
自動化エンジン	n8n	通知・リマインド・外部連携
DB	PostgreSQL	永続データ管理（Docker or AWS RDS）
クラウド	AWS（EC2＋RDS＋S3）	本番環境運用
開発基盤	Docker Compose	各環境の統一化
認証	Django Auth / JWT	ログイン・アクセス制御
通知	Slack / LINE / Gmail	イベント発生時のBot通知




## コア機能一覧（v1構想）

分類	機能	内容
🧑‍💼 ユーザー管理	ログイン／登録／パスワードリセット	Django Auth or JWTベース
📦 商品管理	商品登録・編集・削除	CRUD操作＋在庫追跡
🧾 受注管理	新規注文登録・発送処理	状態変更・履歴追跡
📊 ダッシュボード	売上／在庫可視化	React＋Chart.jsで可視化
🔔 通知自動化	受注・発送・在庫通知	n8nでWebhook連携
🤖 Bot管理	LINE／Slack通知設定	APIキー登録＋連携ON/OFF制御
🔗 外部連携	Webhook受信／送信	n8nと双方向連携（Zapier互換）




## n8n連携構想

トリガー（イベント）	n8nでの処理	通知対象
新規注文	Slackに「🛍️ 新しい注文が入りました！」通知	店舗管理者
発送完了	LINE通知「📦 発送完了しました」	顧客
在庫ゼロ	メール「⚠️ 在庫切れ」	管理者
毎日午前9時	自動在庫チェック→リマインド送信	管理者

🧠 補足:
Django側 → n8n Webhook（POST） → Slack/LINE/Gmail 連携
※逆連携（n8n→Django）もWebhookで双方向通信可能

⸻

## AWS運用設計（本番構築時）

要素	AWSサービス	内容
Webサーバー	EC2	Djangoアプリ稼働（Gunicorn＋Nginx）
DB	RDS (PostgreSQL)	永続データベース
ストレージ	S3	React静的ファイル＆画像管理
通知／監視	CloudWatch	稼働監視・ログ分析
セキュリティ	IAM／セキュリティグループ	鍵管理・アクセス制御


⸻

## 構築フェーズロードマップ（6ヶ月想定）

フェーズ	期間	内容	目的
Phase 0	〜1週	Docker／Codespacesセットアップ	環境構築
Phase 1	1ヶ月目	Django構築（URL→View→Model）	APIの基礎理解
Phase 2	2ヶ月目	React＋Django連携	SPA構築・データ通信
Phase 3	3ヶ月目	n8n連携構築	通知・Bot化
Phase 4	4〜5ヶ月目	AWSデプロイ	実運用化
Phase 5	6ヶ月目	改良・拡張	UI最適化／AI連携拡張


⸻

## 拡張構想（v2以降）

機能カテゴリ	内容
🤖 ChatGPT API連携	自動返信Bot／顧客対応自動化
🧾 PDF出力機能	注文書／レポート自動生成
🧰 外部API統合	BASE／Shopify API対応
🗃️ マルチテナント化	各販売者ごとに独立環境提供
📈 データ分析	売上／在庫のAI分析・予測機能


⸻

## 学習・教育的活用

BotSiteSystemは、
メンティ教育にも最適な「実務型教材」 にできます。

段階	教える内容	技術領域
初級	DjangoのURL〜View〜Model基礎	Pythonサーバー構築力
中級	React連携＋API通信	Webアプリ開発力
上級	n8n連携・AWSデプロイ	自動化・クラウド構築力
実践	拡張・カスタム設計	案件開発スキル
