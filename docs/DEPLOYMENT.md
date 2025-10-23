# デプロイガイド

## AWS デプロイメント

このガイドでは、BotSiteSystemをAWSにデプロイする手順を説明します。

## アーキテクチャ

```
┌─────────────┐
│   Route 53  │ (DNS)
└──────┬──────┘
       │
┌──────▼──────┐
│     ALB     │ (Application Load Balancer)
└──────┬──────┘
       │
   ┌───┴────┐
   │        │
┌──▼───┐ ┌─▼────┐
│ EC2  │ │ EC2  │ (Auto Scaling Group)
│Django│ │React │
└──┬───┘ └──────┘
   │
┌──▼───┐
│ RDS  │ (PostgreSQL)
└──────┘
   │
┌──▼───┐
│  S3  │ (Static Files & Media)
└──────┘
```

## 前提条件

- AWSアカウント
- AWS CLI のインストールと設定
- Terraform または AWS Console へのアクセス

## デプロイ手順

### 1. AWS リソースの準備

#### VPCとセキュリティグループの作成

```bash
# VPCの作成
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# サブネットの作成
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.2.0/24

# セキュリティグループの作成
aws ec2 create-security-group --group-name botsite-sg --description "BotSiteSystem Security Group" --vpc-id <vpc-id>
```

#### RDS (PostgreSQL) のセットアップ

```bash
aws rds create-db-instance \
  --db-instance-identifier botsite-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --master-username admin \
  --master-user-password <password> \
  --allocated-storage 20
```

#### S3 バケットの作成

```bash
aws s3 mb s3://botsite-static-files
aws s3 mb s3://botsite-media-files
```

### 2. EC2 インスタンスのセットアップ

#### バックエンド用EC2インスタンス

```bash
# インスタンスの起動
aws ec2 run-instances \
  --image-id ami-xxxxxxxx \
  --instance-type t3.small \
  --key-name your-key-pair \
  --security-group-ids <sg-id> \
  --subnet-id <subnet-id>

# インスタンスに接続
ssh -i your-key-pair.pem ec2-user@<instance-ip>

# Dockerのインストール
sudo yum update -y
sudo yum install -y docker
sudo service docker start

# アプリケーションのデプロイ
git clone https://github.com/nyanyacyan/BotSiteSystem.git
cd BotSiteSystem
```

### 3. 環境変数の設定

```bash
# .env ファイルを作成
cat > .env << EOF
DJANGO_SECRET_KEY=<your-secret-key>
DJANGO_SETTINGS_MODULE=config.settings.production
DEBUG=False
ALLOWED_HOSTS=your-domain.com

# Database
DB_NAME=botsite_db
DB_USER=admin
DB_PASSWORD=<password>
DB_HOST=<rds-endpoint>
DB_PORT=5432

# AWS
USE_S3=True
AWS_ACCESS_KEY_ID=<your-access-key>
AWS_SECRET_ACCESS_KEY=<your-secret-key>
AWS_STORAGE_BUCKET_NAME=botsite-static-files
AWS_S3_REGION_NAME=ap-northeast-1
EOF
```

### 4. アプリケーションのデプロイ

```bash
# Dockerイメージのビルド
docker-compose -f docker-compose.prod.yml build

# コンテナの起動
docker-compose -f docker-compose.prod.yml up -d

# マイグレーションの実行
docker-compose exec backend python manage.py migrate

# 静的ファイルの収集
docker-compose exec backend python manage.py collectstatic --noinput

# スーパーユーザーの作成
docker-compose exec backend python manage.py createsuperuser
```

### 5. ALB (Application Load Balancer) の設定

```bash
# ターゲットグループの作成
aws elbv2 create-target-group \
  --name botsite-target-group \
  --protocol HTTP \
  --port 8000 \
  --vpc-id <vpc-id>

# ALBの作成
aws elbv2 create-load-balancer \
  --name botsite-alb \
  --subnets <subnet-id-1> <subnet-id-2> \
  --security-groups <sg-id>

# リスナーの作成
aws elbv2 create-listener \
  --load-balancer-arn <alb-arn> \
  --protocol HTTP \
  --port 80 \
  --default-actions Type=forward,TargetGroupArn=<target-group-arn>
```

### 6. Route 53 でDNSを設定

```bash
# ホストゾーンの作成
aws route53 create-hosted-zone --name your-domain.com

# Aレコードの追加（ALBを指す）
# AWS Consoleで設定するか、CLIで設定
```

### 7. SSL/TLS 証明書の設定 (オプション)

```bash
# AWS Certificate Manager で証明書をリクエスト
aws acm request-certificate \
  --domain-name your-domain.com \
  --validation-method DNS

# ALBリスナーにHTTPSを追加
aws elbv2 create-listener \
  --load-balancer-arn <alb-arn> \
  --protocol HTTPS \
  --port 443 \
  --certificates CertificateArn=<cert-arn> \
  --default-actions Type=forward,TargetGroupArn=<target-group-arn>
```

## Auto Scaling の設定

```bash
# 起動テンプレートの作成
aws ec2 create-launch-template \
  --launch-template-name botsite-template \
  --launch-template-data file://launch-template.json

# Auto Scaling グループの作成
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name botsite-asg \
  --launch-template LaunchTemplateName=botsite-template \
  --min-size 1 \
  --max-size 3 \
  --desired-capacity 2 \
  --target-group-arns <target-group-arn> \
  --vpc-zone-identifier "<subnet-id-1>,<subnet-id-2>"
```

## モニタリングとログ

### CloudWatch の設定

```bash
# CloudWatch Logs グループの作成
aws logs create-log-group --log-group-name /aws/botsite/backend
aws logs create-log-group --log-group-name /aws/botsite/frontend

# アラームの設定
aws cloudwatch put-metric-alarm \
  --alarm-name high-cpu \
  --alarm-description "Alert when CPU exceeds 80%" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold
```

## バックアップ

### RDS 自動バックアップ

```bash
aws rds modify-db-instance \
  --db-instance-identifier botsite-db \
  --backup-retention-period 7 \
  --preferred-backup-window "03:00-04:00"
```

### S3 バージョニング

```bash
aws s3api put-bucket-versioning \
  --bucket botsite-static-files \
  --versioning-configuration Status=Enabled
```

## デプロイメントチェックリスト

- [ ] 環境変数が正しく設定されている
- [ ] データベースマイグレーションが完了している
- [ ] 静的ファイルがS3にアップロードされている
- [ ] SSL証明書が設定されている
- [ ] セキュリティグループが適切に設定されている
- [ ] バックアップが設定されている
- [ ] モニタリングとアラートが設定されている
- [ ] ドメイン名が正しく設定されている

## トラブルシューティング

### アプリケーションにアクセスできない
- セキュリティグループの設定を確認
- ALBのヘルスチェックを確認
- EC2インスタンスのログを確認

### データベース接続エラー
- RDSのセキュリティグループを確認
- データベース認証情報を確認
- RDSエンドポイントを確認

### 静的ファイルが表示されない
- S3バケットのパーミッションを確認
- CORS設定を確認
- AWS認証情報を確認

## 参考資料

- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [AWS RDS Documentation](https://docs.aws.amazon.com/rds/)
- [AWS S3 Documentation](https://docs.aws.amazon.com/s3/)
- [Django Deployment Checklist](https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/)
