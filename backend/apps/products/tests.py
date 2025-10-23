from django.test import TestCase
from apps.products.models import Product
from apps.users.models import User


class ProductModelTest(TestCase):
    """Test the Product model."""

    def setUp(self):
        """Set up test user."""
        self.user = User.objects.create_user(
            username='testuser',
            email='test@example.com',
            password='testpass123',
            is_seller=True
        )

    def test_create_product(self):
        """Test creating a product."""
        product = Product.objects.create(
            seller=self.user,
            name='Test Product',
            description='Test Description',
            price=1000.00,
            stock=10,
            status='draft'
        )

        self.assertEqual(product.name, 'Test Product')
        self.assertEqual(product.seller, self.user)
        self.assertEqual(float(product.price), 1000.00)
        self.assertEqual(product.stock, 10)
        self.assertEqual(str(product), 'Test Product')
