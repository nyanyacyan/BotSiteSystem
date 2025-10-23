#!/bin/bash

# BotSiteSystem デプロイメントスクリプト
# このスクリプトは、AWSへのデプロイを自動化します

set -e

echo "========================================="
echo "BotSiteSystem AWS デプロイメント"
echo "========================================="

# 環境変数のチェック
if [ -z "$AWS_REGION" ]; then
    echo "エラー: AWS_REGION 環境変数が設定されていません"
    exit 1
fi

if [ -z "$APP_ENV" ]; then
    echo "エラー: APP_ENV 環境変数が設定されていません (production/staging)"
    exit 1
fi

echo "環境: $APP_ENV"
echo "リージョン: $AWS_REGION"

# Dockerイメージのビルド
echo "Dockerイメージをビルド中..."
docker-compose -f docker-compose.prod.yml build

# ECRにログイン
echo "ECRにログイン中..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

# イメージにタグ付け
echo "イメージにタグを付けています..."
docker tag botsite_backend:latest $ECR_REGISTRY/botsite-backend:latest
docker tag botsite_frontend:latest $ECR_REGISTRY/botsite-frontend:latest

# イメージをプッシュ
echo "イメージをECRにプッシュ中..."
docker push $ECR_REGISTRY/botsite-backend:latest
docker push $ECR_REGISTRY/botsite-frontend:latest

# ECSタスク定義の更新
echo "ECSタスク定義を更新中..."
aws ecs update-service --cluster botsite-cluster --service botsite-backend --force-new-deployment
aws ecs update-service --cluster botsite-cluster --service botsite-frontend --force-new-deployment

echo "========================================="
echo "デプロイメント完了！"
echo "========================================="
