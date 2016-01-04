from django.http import HttpResponse
# from .models import
from django.shortcuts import render


def index(request):
    context = {'manager': Manager.objects.all()}
    return render(request, 'VStorage/index.html', context)


def clients(request):
    context = {
        'clients_list': Client.objects.raw("select * from Client"),
    }
    return render(request, 'VStorage/clients.html', context)


def products(request, branch_id):
    context = {
        'products_list': Product.objects.raw("""
            select distinct * from
            BranchProduct where branch_id=%s""", [branch_id])
    }
    return render(request, 'VStorage/products.html', context)
