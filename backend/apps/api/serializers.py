from rest_framework import serializers
from apps.products.models import Product
from apps.orders.models import Order, OrderItem


class ProductSerializer(serializers.ModelSerializer):
    seller_name = serializers.CharField(source='seller.username', read_only=True)

    class Meta:
        model = Product
        fields = ['id', 'name', 'description', 'price', 'stock', 'status', 
                  'image', 'seller', 'seller_name', 'created_at', 'updated_at']
        read_only_fields = ['seller', 'created_at', 'updated_at']


class OrderItemSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source='product.name', read_only=True)

    class Meta:
        model = OrderItem
        fields = ['id', 'product', 'product_name', 'quantity', 'price']


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)
    customer_name = serializers.CharField(source='customer.username', read_only=True)

    class Meta:
        model = Order
        fields = ['id', 'customer', 'customer_name', 'status', 'total_amount',
                  'shipping_address', 'notes', 'items', 'created_at', 'updated_at']
        read_only_fields = ['customer', 'created_at', 'updated_at']
