from django.http import HttpResponse
from .models import *
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import auth
from .forms import *
from django.db import connection
import json
import datetime


@login_required
def index(request):
    context = {}
    return render(request, 'VStorage/index.html', context)


@login_required
def clients(request):
    context = {
        'clients_list': Client.objects.raw("select * from Client"),
    }
    return render(request, 'VStorage/clients.html', context)


@login_required
def products(request):
    context = {}
    if request.POST:
        rest = {
            "absence": "danger",
            "middle": "",
            "many": "success"
        }
        branch = request.session['branch_id']
        context['products_list'] = Product.objects.raw(
            "call products_in_branch(%s)", [branch])
        context['color'] = rest
        return render(request, 'VStorage/products.html', context)
    return render(request, 'VStorage/products.html', context)


@login_required
def add_product(request):
    context = {}
    return render(request, 'VStorage/add_product.html', context)


@login_required
def ajax_add_product(request):
    form = AddProduct(request.POST)
    if request.is_ajax():
        if form.is_valid():
            product_name = form.cleaned_data.get('product_name')
            product_category = form.cleaned_data.get('product_category')
            product_made = form.cleaned_data.get('product_made')
            product_cost = form.cleaned_data.get('product_cost')
            product_count = form.cleaned_data.get('product_count')
            search = Product.objects.filter(product_name=product_name,
                                            product_category=product_category,
                                            product_made=product_made)
            if search:
                content = json.dumps({'product_name': product_name,
                                      'product_category': product_category,
                                      'product_made': product_made,
                                      'product_cost': product_cost,
                                      'product_count': product_count})
                return HttpResponse(content, content_type='application/json')
            else:
                cursor = connection.cursor()
                cursor.execute(
                    "call add_product(%s,%s,%s,%s,%s,%s)",
                    [product_name, product_category, product_made,
                     product_cost, product_count,
                     request.session['branch_id']])
                cursor.close()
                return HttpResponse("Товар добавлен")
        else:
            return HttpResponse()
    return HttpResponse()


@login_required
def ajax_change_product(request):
    if request.is_ajax():
        product_name = request.POST.get('product_name')
        product_category = request.POST.get('product_category')
        product_made = request.POST.get('product_made')
        product_cost = request.POST.get('product_cost')
        product_count = request.POST.get('product_count')
        cursor = connection.cursor()
        cursor.execute(
            "call change_product(%s,%s,%s,%s,%s,%s)",
            [product_name, product_category, product_made,
             product_cost, product_count, request.session['branch_id']])
        cursor.close()
    return HttpResponse()


@login_required
def new_order(request):
    context = {}
    if request.POST:
        if request.POST.getlist('product_count_b'):
            sess = request.session['basket']
            my_list = request.POST.getlist('product_count_b')
            for i in range(len(sess)):
                sess[i][5] = my_list[i]
            # print(sess)
            request.session['basket'] = sess
        # сессия хранит список выбранных объектов
        # каждый элемент списка - список с данными о продукте
        branch = request.session['branch_id']
        context['order_products_list'] = Product.objects.raw(
            "call products_in_branch(%s)", [branch])
        context['products_count'] = len(request.session['basket'])
        return render(request, 'VStorage/new_order.html', context)
    return render(request, 'VStorage/new_order.html', context)


@login_required
def ajax_add_basket(request):
    if request.is_ajax():
        # print(request.POST)
        product_id = request.POST.get('product_id')
        product_name = request.POST.get('product_name')
        product_category = request.POST.get('product_category')
        product_made = request.POST.get('product_made')
        product_cost = request.POST.get('product_cost')
        # product_count = request.POST.get('product_count')
        sess = request.session['basket']
        product_info = [product_id, product_name,
                        product_category, product_made,
                        product_cost, 1]
        sess.append(product_info)
        request.session['basket'] = sess
        content = json.dumps(request.session['basket'])
        return HttpResponse(content, content_type='application/json')
    return HttpResponse()


@login_required
def basket(request):
    context = {}
    return render(request, "VStorage/basket.html", context)


@login_required
def next_basket(request):
    if request.POST:
        if request.POST.getlist('product_count_b'):
            sess = request.session['basket']
            my_list = request.POST.getlist('product_count_b')
            for i in range(len(sess)):
                sess[i][5] = my_list[i]
            # print(sess)
            request.session['basket'] = sess
    return render(request, "VStorage/next_basket.html", {})


@login_required
def result(request):
    context = {}
    if request.POST:
        context['client_name'] = request.POST['client_name']
        request.session['client_name'] = request.POST['client_name']
        context['client_address'] = request.POST['address']
        request.session['client_address'] = request.POST['address']
        context['client_birthday'] = request.POST['client_birthday']
        request.session['client_birthday'] = request.POST['client_birthday']
        totalcost = 0
        for i in range(len(request.session['basket'])):
            totalcost += (int(request.session['basket'][i][4]) *
                          int(request.session['basket'][i][5]))
        # print(request.session['basket'])
        context['cost'] = totalcost
        request.session['cost'] = totalcost
        return render(request, 'VStorage/result.html', context)
    return render(request, 'VStorage/result.html', context)


@login_required
def endresult(request):
    if request.POST:
        cursor = connection.cursor()
        print(datetime.date.today)
        cursor.execute(
            "call make_order(%s,%s,%s,%s,%s,%s,%s)",
            [request.session['man_id'], request.session['branch_id'],
             request.session['client_name'],
             request.session['client_address'], request.session[
                'client_birthday'],
             request.session['cost'], datetime.date.today()])
        sess = request.session['basket']
        for i in range(len(sess)):
            cursor.execute("""
                call order_product(%s,%s)""", [sess[i][0], sess[i][5]])
        cursor.close()
        del request.session['basket']
        del request.session['client_name']
        del request.session['client_address']
        del request.session['client_birthday']
        del request.session['cost']
        request.session['basket'] = []
        context = {}
        return render(request, 'VStorage/index.html', context)


def login(request):
    auth.logout(request)
    context = {}
    # request.session['branch_id'] = None
    # request.session['branch_address'] = None
    # request.session['basket'] = None
    request.session['basket'] = []
    if request.POST:
        name = request.POST['username']
        password = request.POST['password']
        user = auth.authenticate(username=name, password=password)
        if user is not None:
            if user.username == 'admin':
                return redirect('/admin/')
            elif user.username != 'admin':
                man_dict = {
                    'man_id': Manager.objects.raw("""
                    call get_manager(%s)""", [user.username])
                }
                branch_dict = {
                    'branch': Branch.objects.raw(
                        "call get_branch(%s)", [user])
                }
                request.session['man_id'] = man_dict['man_id'][0].manager_id
                request.session['branch_id'] = branch_dict[
                    'branch'][0].branch_id
                request.session['branch_address'] = branch_dict[
                    'branch'][0].branch_address
                auth.login(request, user)
                return redirect('/storage/')
        else:
            context = {
                'error': "Неверный логин или пароль",
            }
            return render(request, 'VStorage/login.html', context)
    return render(request, 'VStorage/login.html', context)


def logout(request):
    del request.session['branch_id']
    del request.session['branch_address']
    del request.session['basket']
    del request.session['man_id']
    auth.logout(request)
    return redirect('/storage/')
