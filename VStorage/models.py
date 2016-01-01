from __future__ import unicode_literals

from django.db import models


class Auto(models.Model):
    auto_id = models.AutoField(primary_key=True)
    auto_model = models.CharField(max_length=50)
    auto_number = models.CharField(max_length=12)
    branch = models.ForeignKey('Branch', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'Auto'


class Branch(models.Model):
    branch_id = models.AutoField(primary_key=True)
    branch_address = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'Branch'


class Branchproduct(models.Model):
    branchproduct_id = models.AutoField(primary_key=True)
    product_rest = models.IntegerField()
    branch = models.ForeignKey(Branch, models.DO_NOTHING)
    product = models.ForeignKey('Product', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'BranchProduct'


class Client(models.Model):
    client_id = models.AutoField(primary_key=True)
    client_name = models.CharField(max_length=50)
    client_passport = models.CharField(max_length=11)
    client_birthday = models.DateField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'Client'


class Driver(models.Model):
    driver_id = models.AutoField(primary_key=True)
    driver_name = models.CharField(max_length=50)
    driver_birthday = models.DateField()
    driver_salary = models.IntegerField()
    driver_recruitment = models.DateField()
    auto = models.ForeignKey(Auto, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'Driver'


class Manager(models.Model):
    manager_id = models.AutoField(primary_key=True)
    manager_name = models.CharField(max_length=50)
    manager_birthday = models.DateField()
    manager_recruitment = models.DateField()
    manager_salary = models.IntegerField()
    branch = models.ForeignKey(Branch, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'Manager'


class Orderproduct(models.Model):
    orderproduct_id = models.AutoField(primary_key=True)
    product_count = models.IntegerField()
    order = models.ForeignKey('Ordertable', models.DO_NOTHING)
    product = models.ForeignKey('Product', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'OrderProduct'


class Ordertable(models.Model):
    order_id = models.AutoField(primary_key=True)
    order_date = models.DateField()
    order_address = models.CharField(max_length=100)
    order_totalcost = models.FloatField()
    manager = models.ForeignKey(Manager, models.DO_NOTHING)
    client = models.ForeignKey(Client, models.DO_NOTHING)
    branch = models.ForeignKey(Branch, models.DO_NOTHING)
    auto = models.ForeignKey(Auto, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'OrderTable'


class Product(models.Model):
    product_id = models.AutoField(primary_key=True)
    product_name = models.CharField(max_length=50)
    product_cost = models.FloatField()
    product_made = models.CharField(max_length=20)
    product_description = models.CharField(
        max_length=100, blank=True, null=True)
    product_category = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'Product'
