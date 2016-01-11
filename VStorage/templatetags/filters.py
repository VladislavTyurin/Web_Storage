from django import template

register = template.Library()


@register.filter
def get_value(d, key):
    if key > 7:
        return d['many']
    elif key > 0:
        return d['middle']
    elif key == 0:
        return d['absence']


@register.filter
def products_plural(count):
    if count < 10 or count >= 20:
        if count % 10 in (2, 3, 4):
            return str(count) + ' товара'
        elif count % 10 == 1:
            return str(count) + ' товар'
        else:
            return str(count) + ' товаров'
    else:
        return str(count) + ' товаров'
