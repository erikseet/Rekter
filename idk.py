x = int(input("Zadaj km pre prvy den: "))
y = int(input("Zadaj finalne km: "))
den = 1
while x < y:
    x *= 1.1
    den += 1
print(f"na {den}, den prebehne {x:.2f} km")