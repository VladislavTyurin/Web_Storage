from django.http import HttpResponse
from .models import Client
from django.shortcuts import render


def index(request):
    return HttpResponse('Hello, this is your future storage!')


def clients(request):
    context = {
        'clients_list': Client.objects.raw("select * from Client"),
    }
    return render(request, 'VStorage/clients.html', context)


def products(request):
    return HttpResponse('This is product view!')
