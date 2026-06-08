import random
from django.core.mail import send_mail

def generate_otp():
    return str(random.randint(100000, 999999))


def send_otp(email, otp):
    send_mail(
        subject="Your OTP Code",
        message=f"Your OTP is {otp}",
        from_email="authappdemo504@gmail.com",
        recipient_list=[email],
        fail_silently=False
    )