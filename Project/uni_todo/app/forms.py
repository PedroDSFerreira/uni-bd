from django import forms
from django.core.validators import MinLengthValidator

class Test(forms.Form):
    name = forms.CharField(max_length=100)
    quantity = forms.IntegerField()
