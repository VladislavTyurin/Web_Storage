from django import template

register = template.Library()


@register.filter
def get_value(d, key):
    if key not in d:
        return None
    return d[key]
