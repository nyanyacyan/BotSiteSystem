from django.contrib import admin
from .models import Product


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['name', 'seller', 'price', 'stock', 'status', 'created_at']
    list_filter = ['status', 'created_at']
    search_fields = ['name', 'description']
