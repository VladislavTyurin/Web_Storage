from django import forms
from .models import Product


class AddProduct(forms.ModelForm):
    product_count = forms.IntegerField()

    class Meta:
        model = Product
        fields = ['product_name', 'product_category',
                  'product_made', 'product_cost']
