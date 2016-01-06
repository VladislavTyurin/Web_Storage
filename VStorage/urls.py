from django.conf.urls import url

from . import views

app_name = 'store'
urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^clients/$', views.clients, name='clients'),
    url(r'^products/$', views.products, name='products'),
    url(r'^login/$', views.login, name='login'),
    url(r'^logout/$', views.logout, name='logout')
]
