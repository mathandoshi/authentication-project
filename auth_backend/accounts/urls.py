from django.urls import path
from .views import (
    register_user,
    login_user,
    send_otp_view,
    verify_otp_view,
    forgot_password,
    reset_password
)

urlpatterns = [
    path('register/', register_user),
    path('login/', login_user),
    path('send-otp/', send_otp_view),
    path('verify-otp/', verify_otp_view),
    path('forgot-password/', forgot_password),
    path('reset-password/', reset_password),
]