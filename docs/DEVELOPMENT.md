# 開発ガイド

## プロジェクト構造

```
BotSiteSystem/
├── backend/              # Django バックエンド
│   ├── config/          # プロジェクト設定
│   │   ├── settings/    # 環境別設定
│   │   ├── urls.py      # URLルーティング
│   │   └── wsgi.py      # WSGIエントリーポイント
│   ├── apps/            # アプリケーション
│   │   ├── users/       # ユーザー管理
│   │   ├── products/    # 商品管理
│   │   ├── orders/      # 注文管理
│   │   └── api/         # REST API
│   └── manage.py        # Django管理コマンド
├── frontend/            # React フロントエンド
│   ├── src/
│   │   ├── components/  # 再利用可能なコンポーネント
│   │   ├── pages/       # ページコンポーネント
│   │   ├── services/    # API通信
│   │   └── store/       # Redux状態管理
│   └── public/          # 静的ファイル
└── automation/          # n8n ワークフロー
```

## 開発ワークフロー

### 新機能の追加

1. **フィーチャーブランチの作成**
```bash
git checkout -b feature/your-feature-name
```

2. **バックエンド開発**

Djangoアプリの作成：
```bash
cd backend
python manage.py startapp apps/your_app_name
```

モデルの定義 → マイグレーション → ビューの実装 → URLの設定

3. **フロントエンド開発**

コンポーネントの作成：
```bash
cd frontend/src/components
# 新しいコンポーネントファイルを作成
```

4. **テストの作成**

バックエンド：
```bash
cd backend
python manage.py test apps.your_app_name
```

フロントエンド：
```bash
cd frontend
npm test
```

5. **コミットとプッシュ**
```bash
git add .
git commit -m "Add: your feature description"
git push origin feature/your-feature-name
```

## コーディング規約

### Python (Django)

- **スタイルガイド**: PEP 8
- **インポート順序**: 標準ライブラリ → サードパーティ → ローカル
- **命名規則**:
  - クラス: `PascalCase`
  - 関数/変数: `snake_case`
  - 定数: `UPPER_CASE`

### JavaScript (React)

- **スタイルガイド**: Airbnb JavaScript Style Guide
- **命名規則**:
  - コンポーネント: `PascalCase`
  - 関数/変数: `camelCase`
  - 定数: `UPPER_CASE`

## API開発

### エンドポイントの追加

1. **シリアライザーの作成** (`backend/apps/api/serializers.py`)
```python
class YourModelSerializer(serializers.ModelSerializer):
    class Meta:
        model = YourModel
        fields = '__all__'
```

2. **ビューセットの作成** (`backend/apps/api/views.py`)
```python
class YourModelViewSet(viewsets.ModelViewSet):
    queryset = YourModel.objects.all()
    serializer_class = YourModelSerializer
    permission_classes = [permissions.IsAuthenticated]
```

3. **URLの登録** (`backend/apps/api/urls.py`)
```python
router.register(r'your-model', YourModelViewSet)
```

## データベース操作

### マイグレーション

```bash
# マイグレーションファイルの作成
python manage.py makemigrations

# マイグレーションの適用
python manage.py migrate

# マイグレーションの確認
python manage.py showmigrations
```

### シェルでのデータ操作

```bash
python manage.py shell
```

```python
from apps.products.models import Product

# レコードの作成
product = Product.objects.create(
    name="Test Product",
    price=1000,
    stock=10
)

# レコードの取得
products = Product.objects.all()
```

## n8n ワークフロー開発

1. n8nダッシュボードにアクセス: http://localhost:5678
2. 新しいワークフローを作成
3. ノードを追加して自動化フローを構築
4. ワークフローをテスト
5. ワークフローをエクスポート
6. `automation/workflows/` に保存

## デバッグ

### バックエンドデバッグ

```python
# コード内にブレークポイントを追加
import pdb; pdb.set_trace()
```

### フロントエンドデバッグ

- Chrome DevTools を使用
- `console.log()` でデバッグ出力
- React Developer Tools でコンポーネント状態を確認

## テスト

### バックエンドテスト

```bash
# すべてのテストを実行
python manage.py test

# 特定のアプリをテスト
python manage.py test apps.products

# カバレッジレポート
coverage run --source='.' manage.pytest
coverage report
```

### フロントエンドテスト

```bash
# テストの実行
npm test

# カバレッジレポート
npm test -- --coverage
```

## ベストプラクティス

1. **セキュリティ**
   - 機密情報は環境変数で管理
   - SQL インジェクション対策（Django ORM使用）
   - XSS 対策（適切なエスケープ）

2. **パフォーマンス**
   - データベースクエリの最適化
   - キャッシュの活用
   - 遅延読み込みの実装

3. **コード品質**
   - DRY原則の遵守
   - 適切なコメント
   - 定期的なリファクタリング

## 参考資料

- [Django公式ドキュメント](https://docs.djangoproject.com/)
- [React公式ドキュメント](https://react.dev/)
- [n8n公式ドキュメント](https://docs.n8n.io/)
- [REST Framework](https://www.django-rest-framework.org/)
