# -*- coding: utf-8 -*-
# Generated by Django 1.9 on 2016-01-11 07:10
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('VStorage', '0010_auto_20160111_1005'),
    ]

    operations = [
        migrations.AlterField(
            model_name='ordertable',
            name='auto',
            field=models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='VStorage.Auto'),
        ),
    ]
