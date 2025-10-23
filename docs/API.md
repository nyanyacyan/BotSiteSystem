# API ドキュメント

## ベースURL

- 開発環境: `http://localhost:8000/api`
- 本番環境: `https://your-domain.com/api`

## 認証

BotSiteSystemは JWT (JSON Web Token) 認証を使用します。

### トークンの取得

**エンドポイント**: `POST /api/auth/token/`

**リクエスト**:
```json
{
  "username": "your-username",
  "password": "your-password"
}
```

**レスポンス**:
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

### トークンのリフレッシュ

**エンドポイント**: `POST /api/auth/token/refresh/`

**リクエスト**:
```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

### APIリクエストでの認証

すべての認証が必要なエンドポイントでは、Authorizationヘッダーにトークンを含めます：

```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
```

## エンドポイント

### Products (商品)

#### 商品一覧の取得

**エンドポイント**: `GET /api/products/`

**パラメータ**:
- `status` (オプション): 商品ステータスでフィルタリング (`draft`, `published`, `out_of_stock`)
- `page` (オプション): ページ番号
- `page_size` (オプション): 1ページあたりのアイテム数

**レスポンス**:
```json
{
  "count": 100,
  "next": "http://localhost:8000/api/products/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "name": "サンプル商品",
      "description": "商品の説明",
      "price": "1000.00",
      "stock": 10,
      "status": "published",
      "image": "http://localhost:8000/media/products/sample.jpg",
      "seller": 1,
      "seller_name": "seller_user",
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

#### 商品詳細の取得

**エンドポイント**: `GET /api/products/{id}/`

**レスポンス**:
```json
{
  "id": 1,
  "name": "サンプル商品",
  "description": "商品の説明",
  "price": "1000.00",
  "stock": 10,
  "status": "published",
  "image": "http://localhost:8000/media/products/sample.jpg",
  "seller": 1,
  "seller_name": "seller_user",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

#### 商品の作成

**エンドポイント**: `POST /api/products/`

**認証**: 必要

**リクエスト**:
```json
{
  "name": "新商品",
  "description": "新商品の説明",
  "price": "2000.00",
  "stock": 20,
  "status": "draft"
}
```

**レスポンス**: 作成された商品オブジェクト（201 Created）

#### 商品の更新

**エンドポイント**: `PUT /api/products/{id}/` または `PATCH /api/products/{id}/`

**認証**: 必要（商品の所有者または管理者）

**リクエスト** (PATCH):
```json
{
  "stock": 15,
  "status": "published"
}
```

**レスポンス**: 更新された商品オブジェクト

#### 商品の削除

**エンドポイント**: `DELETE /api/products/{id}/`

**認証**: 必要（商品の所有者または管理者）

**レスポンス**: 204 No Content

### Orders (注文)

#### 注文一覧の取得

**エンドポイント**: `GET /api/orders/`

**認証**: 必要

**パラメータ**:
- `status` (オプション): 注文ステータスでフィルタリング
- `page` (オプション): ページ番号

**レスポンス**:
```json
{
  "count": 50,
  "next": "http://localhost:8000/api/orders/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "customer": 2,
      "customer_name": "customer_user",
      "status": "pending",
      "total_amount": "5000.00",
      "shipping_address": "東京都渋谷区...",
      "notes": "配達時間指定あり",
      "items": [
        {
          "id": 1,
          "product": 1,
          "product_name": "サンプル商品",
          "quantity": 2,
          "price": "1000.00"
        }
      ],
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

#### 注文詳細の取得

**エンドポイント**: `GET /api/orders/{id}/`

**認証**: 必要

**レスポンス**: 注文オブジェクト

#### 注文の作成

**エンドポイント**: `POST /api/orders/`

**認証**: 必要

**リクエスト**:
```json
{
  "total_amount": "3000.00",
  "shipping_address": "東京都渋谷区...",
  "notes": "午前中配達希望"
}
```

**レスポンス**: 作成された注文オブジェクト（201 Created）

#### 注文のキャンセル

**エンドポイント**: `POST /api/orders/{id}/cancel/`

**認証**: 必要

**レスポンス**:
```json
{
  "status": "order cancelled"
}
```

## エラーレスポンス

### 400 Bad Request
```json
{
  "field_name": [
    "エラーメッセージ"
  ]
}
```

### 401 Unauthorized
```json
{
  "detail": "認証情報が提供されていません。"
}
```

### 403 Forbidden
```json
{
  "detail": "このアクションを実行する権限がありません。"
}
```

### 404 Not Found
```json
{
  "detail": "見つかりません。"
}
```

### 500 Internal Server Error
```json
{
  "detail": "サーバーエラーが発生しました。"
}
```

## レート制限

- 認証済みユーザー: 1時間あたり1000リクエスト
- 未認証ユーザー: 1時間あたり100リクエスト

レート制限に達した場合、`429 Too Many Requests` が返されます。

## ページネーション

リスト系エンドポイントはページネーションをサポートしています：

- デフォルトページサイズ: 20
- 最大ページサイズ: 100

パラメータ:
- `page`: ページ番号
- `page_size`: 1ページあたりのアイテム数

## 使用例

### cURL

```bash
# トークン取得
curl -X POST http://localhost:8000/api/auth/token/ \
  -H "Content-Type: application/json" \
  -d '{"username":"user","password":"pass"}'

# 商品一覧取得
curl -X GET http://localhost:8000/api/products/ \
  -H "Authorization: Bearer <access-token>"

# 商品作成
curl -X POST http://localhost:8000/api/products/ \
  -H "Authorization: Bearer <access-token>" \
  -H "Content-Type: application/json" \
  -d '{"name":"新商品","price":"1000","stock":10}'
```

### JavaScript (Axios)

```javascript
import axios from 'axios';

const API_URL = 'http://localhost:8000/api';

// トークン取得
const getToken = async (username, password) => {
  const response = await axios.post(`${API_URL}/auth/token/`, {
    username,
    password
  });
  return response.data.access;
};

// 商品一覧取得
const getProducts = async (token) => {
  const response = await axios.get(`${API_URL}/products/`, {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  return response.data;
};

// 商品作成
const createProduct = async (token, productData) => {
  const response = await axios.post(
    `${API_URL}/products/`,
    productData,
    {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    }
  );
  return response.data;
};
```

### Python (Requests)

```python
import requests

API_URL = 'http://localhost:8000/api'

# トークン取得
def get_token(username, password):
    response = requests.post(f'{API_URL}/auth/token/', json={
        'username': username,
        'password': password
    })
    return response.json()['access']

# 商品一覧取得
def get_products(token):
    headers = {'Authorization': f'Bearer {token}'}
    response = requests.get(f'{API_URL}/products/', headers=headers)
    return response.json()

# 商品作成
def create_product(token, product_data):
    headers = {'Authorization': f'Bearer {token}'}
    response = requests.post(
        f'{API_URL}/products/',
        json=product_data,
        headers=headers
    )
    return response.json()
```
