from django.conf.urls import url

from . import views

app_name = 'store'
urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^clients/$', views.clients, name='clients'),
    url(r'^products/$', views.products, name='products'),
    url(r'^login/$', views.login, name='login'),
    url(r'^logout/$', views.logout, name='logout'),
    url(r'^addproduct/$', views.add_product, name='add_product'),
    url(r'^addajax/$', views.ajax_add_product, name='ajax_add_product'),
    url(r'^changeajax/$', views.ajax_change_product, name='ajax_change_product'),
    url(r'^neworder/$', views.new_order, name='new_order'),
    url(r'^basketajax/$', views.ajax_add_basket, name='ajax_add_basket'),
    url(r'^basket/$', views.basket, name='basket'),
    url(r'^basketclient/$', views.next_basket, name='next_basket'),
    url(r'^result/$', views.result, name='result'),
    url(r'^endresult/$', views.endresult, name='res_end'),
]
