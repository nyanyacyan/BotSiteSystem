#!/bin/bash

# BotSiteSystem セットアップ検証スクリプト
# このスクリプトは、プロジェクトのセットアップが正しく行われたかを確認します

set -e

echo "========================================="
echo "BotSiteSystem セットアップ検証"
echo "========================================="

# カラーコード
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# チェック関数
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 が存在します"
        return 0
    else
        echo -e "${RED}✗${NC} $1 が見つかりません"
        return 1
    fi
}

check_directory() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 ディレクトリが存在します"
        return 0
    else
        echo -e "${RED}✗${NC} $1 ディレクトリが見つかりません"
        return 1
    fi
}

echo ""
echo "--- ディレクトリ構造の確認 ---"
check_directory "backend"
check_directory "frontend"
check_directory "automation"
check_directory "deployment"
check_directory "docs"

echo ""
echo "--- バックエンド設定の確認 ---"
check_file "backend/requirements.txt"
check_file "backend/manage.py"
check_file "backend/config/settings/base.py"
check_file "backend/config/settings/development.py"
check_file "backend/config/settings/production.py"
check_file "backend/config/urls.py"
check_file "backend/config/wsgi.py"

echo ""
echo "--- Djangoアプリの確認 ---"
check_directory "backend/apps/users"
check_directory "backend/apps/products"
check_directory "backend/apps/orders"
check_directory "backend/apps/api"

echo ""
echo "--- フロントエンド設定の確認 ---"
check_file "frontend/package.json"
check_file "frontend/public/index.html"
check_file "frontend/src/index.js"
check_file "frontend/src/App.js"

echo ""
echo "--- Docker設定の確認 ---"
check_file "docker-compose.yml"
check_file "docker-compose.prod.yml"
check_file "deployment/docker/Dockerfile.backend"
check_file "deployment/docker/Dockerfile.frontend"
check_file "deployment/docker/Dockerfile.frontend.prod"

echo ""
echo "--- ドキュメントの確認 ---"
check_file "README.md"
check_file "docs/SETUP.md"
check_file "docs/DEVELOPMENT.md"
check_file "docs/DEPLOYMENT.md"
check_file "docs/API.md"
check_file "docs/N8N_WORKFLOWS.md"

echo ""
echo "--- 環境設定ファイルの確認 ---"
check_file ".env.example"
check_file ".gitignore"

echo ""
echo "--- n8n設定の確認 ---"
check_file "automation/README.md"
check_directory "automation/workflows"

echo ""
echo "========================================="
echo "検証完了"
echo "========================================="

echo ""
echo -e "${YELLOW}次のステップ:${NC}"
echo "1. .env.example を .env にコピーして環境変数を設定"
echo "2. docker-compose up -d でコンテナを起動"
echo "3. docker-compose exec backend python manage.py migrate でデータベースをマイグレート"
echo "4. http://localhost:3000 でフロントエンドにアクセス"
echo "5. http://localhost:8000/admin でDjango管理画面にアクセス"
echo "6. http://localhost:5678 でn8nにアクセス"
