# -*- coding: utf-8 -*-
# Generated by Django 1.9 on 2016-01-04 10:17
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('VStorage', '0003_remove_manager_user_id'),
    ]

    operations = [
        migrations.AddField(
            model_name='manager',
            name='user_id',
            field=models.IntegerField(default=None),
            preserve_default=False,
        ),
    ]