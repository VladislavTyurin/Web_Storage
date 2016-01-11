from django.db import models
from django.contrib.auth.models import User


class Client(models.Model):
    client_id = models.AutoField(primary_key=True)
    client_name = models.CharField(max_length=50, null=True, default=None)
    client_passport = models.CharField(max_length=11, null=True, default=None)
    client_birthday = models.DateField(blank=True, null=True, default=None)

    class Meta:
        db_table = 'Client'


class Product(models.Model):
    product_id = models.AutoField(primary_key=True)
    product_name = models.CharField(max_length=50)
    product_cost = models.FloatField()
    product_made = models.CharField(max_length=20)
    product_category = models.CharField(max_length=50)

    class Meta:
        db_table = 'Product'


class Branch(models.Model):
    branch_id = models.AutoField(primary_key=True)
    branch_address = models.CharField(max_length=100)

    class Meta:
        db_table = 'Branch'


class Manager(models.Model):
    manager_id = models.AutoField(primary_key=True)
    manager_name = models.CharField(max_length=50)
    manager_birthday = models.DateField()
    manager_recruitment = models.DateField()
    manager_salary = models.IntegerField()
    branch = models.ForeignKey(Branch, on_delete=models.CASCADE)
    user = models.OneToOneField(User, default=None)

    class Meta:
        db_table = 'Manager'


class Auto(models.Model):
    auto_id = models.AutoField(primary_key=True)
    auto_model = models.CharField(max_length=50)
    auto_number = models.CharField(max_length=12)
    branch = models.ForeignKey(Branch, on_delete=models.CASCADE)

    class Meta:
        db_table = 'Auto'


class Driver(models.Model):
    driver_id = models.AutoField(primary_key=True)
    driver_name = models.CharField(max_length=50)
    driver_birthday = models.DateField()
    driver_salary = models.IntegerField()
    driver_recruitment = models.DateField()
    auto = models.ForeignKey(Auto, on_delete=models.CASCADE)

    class Meta:
        db_table = 'Driver'


class Ordertable(models.Model):
    order_id = models.AutoField(primary_key=True)
    order_date = models.DateField()
    order_address = models.CharField(max_length=100, null=True, default=None)
    order_totalcost = models.FloatField()
    manager = models.ForeignKey(Manager, on_delete=models.CASCADE)
    client = models.ForeignKey(
        Client, on_delete=models.CASCADE, null=True, default=None)
    branch = models.ForeignKey(Branch, on_delete=models.CASCADE)
    auto = models.ForeignKey(
        Auto, on_delete=models.CASCADE, null=True, default=None)

    class Meta:
        db_table = 'OrderTable'


class Branchproduct(models.Model):
    branchproduct_id = models.AutoField(primary_key=True)
    product_rest = models.IntegerField()
    branch = models.ForeignKey(Branch, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)

    class Meta:
        db_table = 'BranchProduct'


class Orderproduct(models.Model):
    orderproduct_id = models.AutoField(primary_key=True)
    product_count = models.IntegerField()
    order = models.ForeignKey(Ordertable, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)

    class Meta:
        db_table = 'OrderProduct'
