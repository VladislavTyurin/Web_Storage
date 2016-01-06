from django.http import HttpResponse
from .models import *
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import auth


@login_required
def index(request):
    user = request.session['login_user']
    context = {}
    context['branch'] = Manager.objects.raw(
        "call get_manager(%s)", [user])
    return render(request, 'VStorage/index.html', context)


def clients(request):
    context = {
        'clients_list': Client.objects.raw("select * from Client"),
    }
    return render(request, 'VStorage/clients.html', context)


@login_required
def products(request):
    if request.POST:
        context = {}
        rest = {}
        for i in range(0, 1):
            rest[i] = "danger"
        for i in range(1, 7):
            rest[i] = ""
        for i in range(7, 11):
            rest[i] = "success"
        branch = request.POST['branch']
        context['products_list'] = Product.objects.raw(
            "call products_in_branch(%s)", [branch])
        context['color'] = rest
        return render(request, 'VStorage/products.html', context)


def login(request):
    context = {}
    if request.POST:
        name = request.POST['username']
        password = request.POST['password']
        user = auth.authenticate(username=name, password=password)
        if user is not None:
            request.session['login_user'] = user.username
            auth.login(request, user)
            return redirect('/storage/')
        else:
            context = {
                'error': "Неверный логин или пароль",
            }
            return render(request, 'VStorage/login.html', context)
    return render(request, 'VStorage/login.html', context)


def logout(request):
    auth.logout(request)
    return redirect('/storage')
