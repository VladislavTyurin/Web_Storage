from django.conf.urls import url

from . import views

app_name = 'store'
urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^clients/$', views.clients, name='clients'),
    url(r'^products/(?P<branch_id>[1-6])/$', views.products, name='products'),
]
