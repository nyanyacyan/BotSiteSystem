# AWS デプロイメント設定

## Terraform 設定ファイル

このディレクトリには、AWS インフラをコードとして管理するための設定が含まれています。

## 構成

- `main.tf`: メインのTerraform設定
- `variables.tf`: 変数定義
- `outputs.tf`: 出力値定義
- `terraform.tfvars.example`: 変数の例

## 使用方法

### 1. Terraform のインストール

```bash
# macOS
brew install terraform

# Linux
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### 2. AWS 認証情報の設定

```bash
aws configure
```

### 3. 変数ファイルの作成

```bash
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars を編集
```

### 4. Terraform の初期化

```bash
terraform init
```

### 5. プランの確認

```bash
terraform plan
```

### 6. インフラのデプロイ

```bash
terraform apply
```

### 7. インフラの削除

```bash
terraform destroy
```

## 注意事項

- `terraform.tfvars` は `.gitignore` に含まれています（機密情報を含むため）
- 本番環境では、必ず別のステート管理を設定してください（S3 backend推奨）
