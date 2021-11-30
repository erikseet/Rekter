nazov = dict() # {"k" : "v" , "k2" : "v2"}

for i in range(0,2):
    a = input("Zadaj meno: ")
    b = input("zadaj heslo: ")
    nazov[a] = b
print("A teraz zadaj nazov uctu a jeho heslo: ")
c = input("Zadaj meno: ")
d = input("zadaj heslo: ")

if c in nazov:
    if nazov[c] == d:
        print("Uspesne si prihlaseny!")
    else:
        print("Zadal si zle heslo!")
else:
    print("Zadal si zly login")